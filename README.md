# NoCFuzzer

This repository contains the source code for **NoCFuzzer**, a fuzzing-based
framework for verifying Network-on-Chip (NoC) designs in a UVM environment.

## Paper

Ruiyang Ma, Jiayi Huang, Shijian Zhang, Yuan Xie, and Guojie Luo,
“NoCFuzzer: Automating NoC Verification in UVM,” *IEEE Transactions on
Computer-Aided Design of Integrated Circuits and Systems*, vol. 44, no. 1,
pp. 371–384, January 2025.

[Paper DOI](https://doi.org/10.1109/TCAD.2024.3430195)

## Repository layout

- `noc_mesh_fuzz/` — Mesh-level NoC fuzzing flow, including the DUT simulation,
  UVM testbench, AFL-based fuzzer, proxy, and seed inputs.
- `noc_router_fuzz/` — Router-level NoC fuzzing flow, including the router
  simulation, UVM testbench, AFL-based fuzzer, proxy, and seed inputs.
- `noc_uvm/` — Standalone mesh and router UVM testbench sources.

Each fuzzing project includes its own `README.md`, `Makefile`, `fuzz.py`,
`setup.sh`, and seed-generation script. `AFL_hardware/` contains the classic
AFL 2.57b source used by these flows; `afl_proxy/` contains the C bridge
between AFL and the simulator.

## Build and run

The simulation flows require Synopsys VCS with UVM support, plus a configured
VCS license. Set `VCS_HOME` to your local VCS installation directory and make
sure `vcs` and `urg` are available on `PATH`.

For example, from either `noc_mesh_fuzz/` or `noc_router_fuzz/`:

```sh
export VCS_HOME=/path/to/your/vcs
make
python3 fuzz.py
```

The fuzzing scripts start a 24-hour run by default. See each project's README
for the corresponding DUT and output details.

## Third-party code

The vendored AFL source retains its upstream license and notices in
`AFL_hardware/`.
