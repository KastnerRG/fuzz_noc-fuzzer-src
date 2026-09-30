# Mesh NoCFuzzer flow

This directory contains the mesh-level NoC fuzzing flow: the mesh DUT and UVM
testbench, the AFL source, the AFL-to-simulator proxy, and the initial seeds.

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

The script starts the mesh simulation and AFL. The default fuzzing duration is
24 hours. Simulation output is written under `noc_mesh33_sim/` and the project
directory.
