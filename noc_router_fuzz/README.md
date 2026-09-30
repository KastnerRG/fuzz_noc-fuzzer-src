# Router NoCFuzzer flow

This directory contains the router-level NoC fuzzing flow: the router DUT and
UVM testbench, the AFL source, the AFL-to-simulator proxy, and the seed inputs.

## Requirements

- GNU Make, a C compiler, and Python 3
- Synopsys VCS with UVM support and a locally configured license
- `vcs` and `urg` available on `PATH`; set `VCS_HOME` to the VCS installation
  directory

## Build and run

From this directory, configure VCS and build the fuzzer, proxy, and simulator:

```sh
export VCS_HOME=/path/to/your/vcs
make
python3 fuzz.py
```

The script starts the router simulation and AFL. The default fuzzing duration
is 24 hours. Results are written under `afl_result/` and simulation output is
written to `tb-output.txt`.

## Native router integration

The native integration is a separate router testbench and AFL proxy for DUT line and branch feedback.
It leaves the original FIFO flow above unchanged.
Build its open source components from this directory:

```sh
make -C AFL_hardware afl-fuzz afl-showmap
make -C router_simple -f Makefile.native native-proxy
python3 integration/test_native.py
python3 integration/test_runner.py
```

With VCS and its license configured, run the integration checks and a short campaign:

```sh
python3 integration/run.py /tmp/nocfuzzer-results --source . --duration 30
```

The runner compiles `router_simple/Makefile.native` in a result workspace and reports exit code 77 when VCS or its license is unavailable.
It checks replay stability, DUT feedback, input parsing, scoreboard error detection, and AFL corpus discoveries.
