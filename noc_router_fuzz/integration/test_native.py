#!/usr/bin/env python3
"""Exercise the native AFL forkserver and feedback framing without VCS."""

import ctypes
import os
from pathlib import Path
import select
import shutil
import signal
import struct
import subprocess
import tempfile
import time
import unittest


MAP_SIZE = 65536
FORKSERVER_FD = 198
TIMEOUT = 5
LIBC = ctypes.CDLL(None, use_errno=True)
LIBC.shmget.argtypes = [ctypes.c_int, ctypes.c_size_t, ctypes.c_int]
LIBC.shmget.restype = ctypes.c_int
LIBC.shmat.argtypes = [ctypes.c_int, ctypes.c_void_p, ctypes.c_int]
LIBC.shmat.restype = ctypes.c_void_p
LIBC.shmdt.argtypes = [ctypes.c_void_p]
LIBC.shmctl.argtypes = [ctypes.c_int, ctypes.c_int, ctypes.c_void_p]

MOCK_SIMULATOR = r'''#!/usr/bin/env python3
import os
from pathlib import Path
import signal
import struct
import sys

source = next(arg.split("=", 1)[1] for arg in sys.argv if arg.startswith("+nocfuzzer_input="))
mode = Path(source).read_text()
Path("simulator.pid.tmp").write_text(str(os.getpid()))
os.replace("simulator.pid.tmp", "simulator.pid")
fd = int(os.environ["NOCFUZZER_FEEDBACK_FD"])
magic, length, lines, branches = 0x4e4f4346, 4, 2, 2
payload = bytes([1, 0, 1, 0])
if mode == "missing":
    sys.exit(0)
if mode == "signal":
    os.kill(os.getpid(), signal.SIGABRT)
if mode == "timeout":
    while True:
        signal.pause()
if mode == "empty":
    length = lines = branches = 0
    payload = b""
elif mode == "zero":
    payload = bytes(4)
elif mode == "short-header":
    os.write(fd, b"NO")
    sys.exit(0)
elif mode == "short-payload":
    payload = b"\x01"
elif mode == "oversized":
    length, lines, branches = 65537, 1, 65536
    payload = b""
elif mode == "bad-magic":
    magic = 0
elif mode == "missing-lines":
    lines, branches = 0, 4
elif mode == "missing-branches":
    lines, branches = 4, 0
elif mode == "bad-shape":
    lines, branches = 1, 1
elif mode == "first":
    length, lines, branches = 32, 16, 16
    payload = bytes([1]) + bytes(30) + bytes([1])
elif mode == "second":
    length, lines, branches = 2, 1, 1
    payload = bytes([0, 1])
elif mode == "large":
    length, lines, branches = 65536, 32768, 32768
    payload = bytes([1]) + bytes(65534) + bytes([1])
data = struct.pack("=IIII", magic, length, lines, branches) + payload
# Small writes also exercise framing across more than one pipe read.
for offset in range(0, len(data), 37):
    remaining = memoryview(data)[offset:offset + 37]
    while remaining:
        remaining = remaining[os.write(fd, remaining):]
os.close(fd)
if mode == "valid-then-signal":
    os.kill(os.getpid(), signal.SIGABRT)
sys.exit(42 if mode == "nonzero-exit" else 0)
'''


def read_exact(fd, size):
    deadline = time.monotonic() + TIMEOUT
    data = bytearray()
    while len(data) < size:
        remaining = deadline - time.monotonic()
        if remaining <= 0 or not select.select([fd], [], [], remaining)[0]:
            raise TimeoutError("native proxy did not respond before the deadline")
        chunk = os.read(fd, size - len(data))
        if not chunk:
            raise EOFError("native proxy closed the AFL status channel")
        data.extend(chunk)
    return bytes(data)


class Forkserver:
    """A real AFL parent with its control/status descriptors and SysV bitmap."""

    def __init__(self, proxy, directory):
        self.directory = directory
        self.input = directory / "input"
        self.input.write_text("good")
        self.child = None
        self.proxy_status = None
        self.shmid = LIBC.shmget(0, MAP_SIZE, 0o600 | 0o1000)
        if self.shmid < 0:
            raise OSError(ctypes.get_errno(), "shmget")
        self.address = LIBC.shmat(self.shmid, None, 0)
        if self.address == ctypes.c_void_p(-1).value:
            LIBC.shmctl(self.shmid, 0, None)
            raise OSError(ctypes.get_errno(), "shmat")
        # Mark for removal now; both processes retain it while attached.
        LIBC.shmctl(self.shmid, 0, None)
        self.bitmap = (ctypes.c_ubyte * MAP_SIZE).from_address(self.address)
        control_read, self.control = os.pipe()
        self.status, status_write = os.pipe()
        self.pid = os.fork()
        if self.pid == 0:
            try:
                os.setsid()
                os.dup2(control_read, FORKSERVER_FD)
                os.dup2(status_write, FORKSERVER_FD + 1)
                for fd in (control_read, self.control, self.status, status_write):
                    if fd not in (FORKSERVER_FD, FORKSERVER_FD + 1):
                        os.close(fd)
                log = os.open(directory / "proxy.log", os.O_WRONLY | os.O_CREAT, 0o600)
                os.dup2(log, 1)
                os.dup2(log, 2)
                os.close(log)
                os.chdir(directory)
                os.execve(proxy, [str(proxy), str(self.input)],
                          os.environ | {"__AFL_SHM_ID": str(self.shmid)})
            finally:
                os._exit(127)
        os.close(control_read)
        os.close(status_write)
        try:
            read_exact(self.status, 4)
        except BaseException:
            self.close()
            raise

    def start(self, mode):
        self.input.write_text(mode)
        (self.directory / "simulator.pid").unlink(missing_ok=True)
        os.write(self.control, struct.pack("=I", 0))
        self.child = struct.unpack("=I", read_exact(self.status, 4))[0]
        return self.child

    def finish(self):
        status = struct.unpack("=I", read_exact(self.status, 4))[0]
        self.child = None
        return status

    def run(self, mode):
        self.start(mode)
        return self.finish()

    def wait(self):
        if self.proxy_status is not None:
            return self.proxy_status
        deadline = time.monotonic() + TIMEOUT
        while time.monotonic() < deadline:
            pid, status = os.waitpid(self.pid, os.WNOHANG)
            if pid:
                self.proxy_status = status
                return status
            time.sleep(0.01)
        raise TimeoutError("native proxy failed to exit")

    def close(self):
        os.close(self.control)
        os.close(self.status)
        try:
            self.wait()
        except TimeoutError:
            try:
                os.killpg(self.pid, signal.SIGKILL)
            except ProcessLookupError:
                pass
            _, self.proxy_status = os.waitpid(self.pid, 0)
        finally:
            LIBC.shmdt(self.address)

    def __enter__(self):
        return self

    def __exit__(self, *_args):
        self.close()


class NativeProxyTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.build = tempfile.TemporaryDirectory(prefix="nocfuzzer-proxy-test-")
        cls.proxy = Path(cls.build.name) / "native-proxy"
        source = Path(__file__).resolve().parent.parent / "router_simple/fuzz_interface/proxy.cpp"
        compiler = shutil.which("g++")
        if not compiler:
            raise RuntimeError("g++ is required for NoCFuzzer native proxy tests")
        subprocess.run([compiler, "-std=c++17", "-Wall", "-Wextra", "-Werror",
                        str(source), "-o", str(cls.proxy)], check=True)

    @classmethod
    def tearDownClass(cls):
        cls.build.cleanup()

    def setUp(self):
        self.work = tempfile.TemporaryDirectory(prefix="nocfuzzer-case-")
        self.addCleanup(self.work.cleanup)
        self.directory = Path(self.work.name)
        simulator = self.directory / "simv"
        simulator.write_text(MOCK_SIMULATOR)
        simulator.chmod(0o755)

    def test_feedback_and_prior_map_are_isolated(self):
        stale = self.directory / "simv.vdb/snps/coverage/db/testdata/stale"
        stale.mkdir(parents=True)
        (stale / "stale.data").write_text("old measurement")
        design = stale.parent.parent / "design"
        design.mkdir()
        (design / "static.data").write_text("compiled design")
        with Forkserver(self.proxy, self.directory) as server:
            self.assertEqual(server.run("first"), 0)
            self.assertEqual(bytes(server.bitmap), bytes([1]) + bytes(30) + bytes([1]) + bytes(MAP_SIZE - 32))
            self.assertFalse(stale.exists())
            self.assertEqual((design / "static.data").read_text(), "compiled design")
            self.assertEqual(server.run("second"), 0)
            self.assertEqual(bytes(server.bitmap), bytes([0, 1]) + bytes(MAP_SIZE - 2))

    def test_map_larger_than_pipe_capacity_completes(self):
        with Forkserver(self.proxy, self.directory) as server:
            self.assertEqual(server.run("large"), 0)
            self.assertEqual(bytes(server.bitmap), bytes([1]) + bytes(MAP_SIZE - 2) + bytes([1]))

    def test_incomplete_or_invalid_feedback_is_infrastructure_failure(self):
        for mode in ("missing", "empty", "zero", "short-header", "short-payload", "oversized",
                     "bad-magic", "missing-lines", "missing-branches", "bad-shape", "nonzero-exit"):
            with self.subTest(mode=mode), Forkserver(self.proxy, self.directory) as server:
                server.start(mode)
                with self.assertRaises(EOFError):
                    server.finish()
                status = server.wait()
                self.assertTrue(os.WIFEXITED(status))
                self.assertEqual(os.WEXITSTATUS(status), 70)

    def test_genuine_child_signals_are_preserved(self):
        with Forkserver(self.proxy, self.directory) as server:
            for mode in ("signal", "valid-then-signal"):
                with self.subTest(mode=mode):
                    status = server.run(mode)
                    self.assertTrue(os.WIFSIGNALED(status))
                    self.assertEqual(os.WTERMSIG(status), signal.SIGABRT)
            self.assertEqual(server.run("good"), 0)

    def test_standalone_showmap_execution_preserves_feedback_and_signal(self):
        source = self.directory / "input"
        bitmap = self.directory / "feedback.bin"
        environment = os.environ | {"NOCFUZZER_MAP_FILE": str(bitmap)}
        environment.pop("__AFL_SHM_ID", None)
        source.write_text("good")
        result = subprocess.run([self.proxy, source], cwd=self.directory,
                                env=environment, timeout=TIMEOUT, capture_output=True)
        self.assertEqual(result.returncode, 0, result.stderr.decode())
        self.assertEqual(bitmap.read_bytes(), bytes([1, 0, 1, 0]) + bytes(MAP_SIZE - 4))
        source.write_text("valid-then-signal")
        result = subprocess.run([self.proxy, source], cwd=self.directory,
                                env=environment, timeout=TIMEOUT, capture_output=True)
        self.assertEqual(result.returncode, -signal.SIGABRT)

    def test_afl_can_kill_the_reported_simulator_pid(self):
        with Forkserver(self.proxy, self.directory) as server:
            child = server.start("timeout")
            marker = self.directory / "simulator.pid"
            deadline = time.monotonic() + TIMEOUT
            while not marker.exists() and time.monotonic() < deadline:
                time.sleep(0.01)
            self.assertTrue(marker.exists(), "mock simulator did not start")
            self.assertEqual(int(marker.read_text()), child)
            os.kill(child, signal.SIGKILL)
            status = server.finish()
            self.assertTrue(os.WIFSIGNALED(status))
            self.assertEqual(os.WTERMSIG(status), signal.SIGKILL)
            self.assertEqual(bytes(server.bitmap), bytes(MAP_SIZE))
            with self.assertRaises(ProcessLookupError):
                os.kill(child, 0)
            self.assertEqual(server.run("good"), 0)


if __name__ == "__main__":
    unittest.main(verbosity=2)
