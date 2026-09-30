#!/usr/bin/env python3
"""Check that only identified VCS license failures skip the native runner."""

from contextlib import redirect_stdout
import importlib.util
import io
from pathlib import Path
import tempfile
import unittest
from unittest import mock


SPEC = importlib.util.spec_from_file_location("nocfuzzer_runner", Path(__file__).with_name("run.py"))
RUNNER = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(RUNNER)


class RunnerLicenseTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory(prefix="nocfuzzer-runner-test-")
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        self.source = self.root / "source"
        (self.source / "router_simple").mkdir(parents=True)
        self.output = self.root / "results"

    def run_main(self, build_code=0, build_text="", runtime_text="", runtime_code=1):
        def command(args, cwd, log, **kwargs):
            if args[0] == "make":
                log.write_text(build_text)
                return build_code
            log.write_text("showmap: target returned without instrumentation\n")
            Path(kwargs["env"]["NOCFUZZER_SIM_LOG"]).write_text(runtime_text)
            return runtime_code

        with mock.patch.object(RUNNER.sys, "argv", ["run.py", str(self.output), "--source", str(self.source)]), \
                mock.patch.object(RUNNER.shutil, "which", return_value="/tools/vcs/bin/vcs"), \
                mock.patch.dict(RUNNER.os.environ, {"VCS_HOME": "/tools/vcs"}), \
                mock.patch.object(RUNNER.resource, "setrlimit"), \
                mock.patch.object(RUNNER.signal, "signal"), \
                mock.patch.object(RUNNER, "command", side_effect=command), \
                redirect_stdout(io.StringIO()) as output:
            result = RUNNER.main()
        return result, output.getvalue()

    def test_compile_license_failure_skips(self):
        result, output = self.run_main(build_code=1, build_text="Error-[LIC-NOAVAIL] License is not available")
        self.assertEqual(result, 77)
        self.assertIn("build.log", output)

    def test_runtime_license_failure_reads_simulator_log(self):
        result, output = self.run_main(runtime_text="Failed to checkout feature VCSRuntime_Net")
        self.assertEqual(result, 77)
        self.assertIn("idle.sim.log", output)

    def test_arbitrary_compile_failure_does_not_skip(self):
        with self.assertRaisesRegex(RuntimeError, "VCS compilation failed"):
            self.run_main(build_code=1, build_text="undefined reference to getCov")

    def test_arbitrary_runtime_failure_does_not_skip(self):
        with self.assertRaisesRegex(RuntimeError, "idle returned 1, expected 0"):
            self.run_main(runtime_text="UVM_FATAL: bad simulator setup")

    def test_unrelated_checkout_failure_does_not_skip(self):
        with self.assertRaisesRegex(RuntimeError, "VCS compilation failed"):
            self.run_main(build_code=1, build_text="failed to checkout source files")

    def test_successful_process_with_invalid_feedback_does_not_skip(self):
        with self.assertRaises(OSError):
            self.run_main(runtime_code=0, runtime_text="Warning: previous license checkout failed")

    def test_missing_runtime_log_is_not_a_license_failure(self):
        self.assertFalse(RUNNER.license_unavailable(self.root / "absent.log"))


if __name__ == "__main__":
    unittest.main(verbosity=2)
