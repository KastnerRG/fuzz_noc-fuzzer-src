#!/usr/bin/env python3
"""Validate and fuzz NoCFuzzer's native VCS/UVM router example."""

import argparse
from contextlib import contextmanager, suppress
import json
import os
from pathlib import Path
import re
import resource
import shutil
import signal
import subprocess
import sys


LICENSE_ERRORS = re.compile(
    r"cannot obtain a license|license checkout failed|"
    r"(?:failed|unable) to check\s*out[^\n]*(?:license|feature)|"
    r"no such feature exists|license server machine is down|"
    r"cannot connect to license server|licensed number of users already reached|"
    r"error-\[lic-noavail\]",
    re.IGNORECASE,
)


class LicenseUnavailable(RuntimeError):
    pass


def license_unavailable(log):
    return log.is_file() and LICENSE_ERRORS.search(log.read_text(errors="replace")) is not None


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def interrupted(signum, _frame):
    # Unwind owned subprocess groups before the suite kills this worker.
    signal.signal(signal.SIGTERM, signal.SIG_IGN)
    signal.signal(signal.SIGINT, signal.SIG_IGN)
    raise SystemExit(128 + signum)


@contextmanager
def process(args, cwd, log, env=None):
    with log.open("w") as output:
        child = subprocess.Popen([str(arg) for arg in args], cwd=cwd,
                                 env=os.environ | (env or {}), stdout=output,
                                 stderr=subprocess.STDOUT, start_new_session=True)
        try:
            yield child
        finally:
            with suppress(ProcessLookupError):
                os.killpg(child.pid, signal.SIGTERM)
            with suppress(subprocess.TimeoutExpired):
                child.wait(timeout=5)
            with suppress(ProcessLookupError):
                os.killpg(child.pid, signal.SIGKILL)
            child.wait()


def command(args, cwd, log, seconds=120, env=None):
    with process(args, cwd, log, env) as child:
        try:
            return child.wait(timeout=seconds)
        except subprocess.TimeoutExpired as error:
            raise RuntimeError(f"Command timed out; see {log}") from error


def read_map(path):
    entries = {}
    for line in path.read_text().splitlines():
        offset, count = map(int, line.split(":"))
        require(0 <= offset < 65536 and count > 0, f"Malformed hardware map: {path}")
        entries[offset] = count
    require(entries, f"No hardware feedback: {path}")
    return entries


def check_campaign(directory, required_offsets):
    stats_path = directory / "fuzzer_stats"
    stats = dict(line.split(":", 1) for line in stats_path.read_text().splitlines() if ":" in line)
    stats = {key.strip(): value.strip() for key, value in stats.items()}
    require(int(stats.get("execs_done", "0")) > 0, "No NoCFuzzer AFL executions")
    require(int(stats.get("paths_found", "0")) > 0,
            "NoCFuzzer hardware feedback selected no mutated input")
    bitmap = (directory / "fuzz_bitmap").read_bytes()
    require(len(bitmap) == 65536, "Missing or truncated NoCFuzzer campaign bitmap")
    require(all(bitmap[offset] != 255 for offset in required_offsets),
            "NoCFuzzer's real DUT feedback did not reach the campaign bitmap")
    discoveries = list((directory / "queue").glob("id:*,src:*"))
    require(discoveries, "No mutated NoCFuzzer inputs retained in the AFL corpus")
    return stats


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("output", type=Path)
    parser.add_argument("--duration", type=int, default=30)
    parser.add_argument("--source", type=Path,
                        default=Path("/opt/fuzzers/nocfuzzer/noc_router_fuzz"))
    args = parser.parse_args()
    require(args.duration > 0, "Duration must be positive")
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    resource.setrlimit(resource.RLIMIT_CORE, (0, 0))
    signal.signal(signal.SIGTERM, interrupted)
    signal.signal(signal.SIGINT, interrupted)
    if not shutil.which("vcs") or not os.environ.get("VCS_HOME"):
        print("SKIP: NoCFuzzer requires host-mounted VCS/UVM and a configured VCS license.")
        return 77

    work = output / "work"
    shutil.copytree(args.source, work)
    simulation = work / "router_simple"
    build_log = output / "build.log"
    code = command(["make", "-f", "Makefile.native", "comp", "-j", os.environ.get("BUILD_JOBS", "8")],
                   simulation, build_log, seconds=300)
    if code:
        if license_unavailable(build_log):
            print(f"SKIP: VCS license unavailable; see {build_log}")
            return 77
        raise RuntimeError(f"NoCFuzzer VCS compilation failed ({code}); see {build_log}")

    checks = output / "checks"
    checks.mkdir()
    inputs = checks / "inputs"
    inputs.mkdir()
    # Five ports, two four-byte transactions per port; all-zero is idle.
    idle = inputs / "idle"
    traffic = inputs / "traffic"
    idle.write_bytes(bytes(40))
    traffic.write_bytes(bytes([255, 2, 0, 0]) * 10)
    showmap = work / "AFL_hardware/afl-showmap"
    proxy = work / "native-proxy"

    def probe(label, input_path, *plusargs, expected=0, check_license=False):
        map_path = checks / f"{label}.map"
        log = checks / f"{label}.log"
        simulation_log = checks / f"{label}.sim.log"
        # A real scoreboard fatal may terminate before coverage is dumped.
        # Quiet showmap preserves its signal status even when that map is empty.
        options = ["-q"] if expected == 2 else []
        code = command([showmap, *options, "-m", "none", "-t", "20000", "-o", map_path,
                        "--", proxy, input_path, *plusargs], simulation, log, seconds=30,
                       env={"NOCFUZZER_SIM_LOG": str(simulation_log)})
        if code != expected and check_license and license_unavailable(simulation_log):
            raise LicenseUnavailable(f"VCS runtime license unavailable; see {simulation_log}")
        require(code == expected, f"NoCFuzzer {label} returned {code}, expected {expected}; see {log}")
        return read_map(map_path) if expected == 0 else None

    try:
        idle_map = probe("idle", idle, check_license=True)
    except LicenseUnavailable as error:
        print(f"SKIP: {error}")
        return 77
    traffic_map = probe("traffic", traffic)
    repeated = probe("idle-replay", idle)
    traffic_repeated = probe("traffic-replay", traffic)
    require(idle_map == repeated and traffic_map == traffic_repeated,
            "NoCFuzzer hardware coverage changed when replaying the same input")
    require(set(traffic_map) - set(idle_map), "No input-dependent NoCFuzzer DUT coverage")

    # Exercise the binary parser, including the upstream 1001-byte buffer limit
    # and incomplete port groups that AFL's length mutations can produce.
    parser_inputs = {
        "empty": b"",
        "short-tail": bytes([255, 2, 0]),
        "single-packet": bytes([255, 2, 0, 0]),
        "packet-with-tail": bytes([255, 2, 0, 0, 255, 255, 255]),
        "long-idle": bytes(1044),
        "late-packet": bytes(1040) + bytes([255, 2, 0, 0]),
    }
    parser_maps = {}
    for label, data in parser_inputs.items():
        path = inputs / label
        path.write_bytes(data)
        parser_maps[label] = probe(label, path)
    require(parser_maps["empty"] == parser_maps["short-tail"],
            "An incomplete transaction changed NoCFuzzer DUT coverage")
    require(set(parser_maps["single-packet"]) - set(idle_map),
            "NoCFuzzer ignored a complete transaction in a partial port group")
    require(parser_maps["single-packet"] == parser_maps["packet-with-tail"],
            "Trailing partial transaction bytes changed NoCFuzzer DUT coverage")
    require(set(parser_maps["late-packet"]) - set(parser_maps["long-idle"]),
            "NoCFuzzer ignored traffic beyond the upstream input-buffer limit")
    # No-feedback success must be an infrastructure failure, never a valid map.
    no_map = checks / "disabled-feedback.map"
    no_log = checks / "disabled-feedback.log"
    disabled_code = command([showmap, "-m", "none", "-t", "20000", "-o", no_map,
                             "--", proxy, traffic, "+nocfuzzer_disable_feedback"],
                            simulation, no_log, seconds=30,
                            env={"NOCFUZZER_SIM_LOG": str(checks / "disabled-feedback.sim.log")})
    require(disabled_code != 0 and (not no_map.exists() or not no_map.read_text().strip()),
            "Disabled NoCFuzzer feedback was accepted")
    probe("corrupt-packet", traffic, "+nocfuzzer_corrupt_packet", expected=2)
    require("Wrong Packet" in (checks / "corrupt-packet.sim.log").read_text(errors="replace"),
            "The packet-corruption control did not exercise the UVM scoreboard")

    seeds = output / "seeds"
    seeds.mkdir()
    shutil.copy(idle, seeds / "idle")
    campaign = output / "afl"
    env = {"AFL_SKIP_CPUFREQ": "1", "AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES": "1",
           "AFL_NO_AFFINITY": "1", "AFL_NO_UI": "1",
           "NOCFUZZER_SIM_LOG": str(output / "last-simulation.log")}
    with process([work / "AFL_hardware/afl-fuzz", "-d", "-m", "none", "-t", "20000",
                  "-i", seeds, "-o", campaign, "--", proxy, "@@"],
                 simulation, output / "afl.log", env) as child:
        try:
            code = child.wait(timeout=args.duration)
            require(code == 0, f"NoCFuzzer AFL failed ({code}); see {output / 'afl.log'}")
        except subprocess.TimeoutExpired:
            # Signal AFL only so it can finish bookkeeping and stop its child.
            child.send_signal(signal.SIGINT)
            try:
                code = child.wait(timeout=25)
            except subprocess.TimeoutExpired as error:
                raise RuntimeError("NoCFuzzer AFL failed to stop cleanly") from error
            require(code == 0, f"NoCFuzzer AFL shutdown failed ({code})")
    stats = check_campaign(campaign, idle_map)
    discovery = next((campaign / "queue").glob("id:*,src:*"))
    discovery_map = probe("discovery-replay", discovery)
    require(set(discovery_map) - set(idle_map),
            "The retained mutation did not replay to new DUT coverage")
    summary = {"status": "passed", "target": "router", "metrics": ["DUT line", "DUT branch"],
               "idle_points": len(idle_map), "traffic_points": len(traffic_map),
               "deterministic_replay": True, "disabled_feedback_rejected": True,
               "input_parser_checks": list(parser_inputs),
               "corrupted_packet_detected": True, "afl": stats}
    (output / "summary.json").write_text(json.dumps(summary, indent=2) + "\n")
    print(f"Verified NoCFuzzer: {stats['execs_done']} executions, "
          f"{stats['paths_found']} feedback discoveries; replay and scoreboard controls passed.")
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (OSError, ValueError, RuntimeError) as error:
        print(error, file=sys.stderr)
        sys.exit(1)
