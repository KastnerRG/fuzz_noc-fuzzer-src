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
