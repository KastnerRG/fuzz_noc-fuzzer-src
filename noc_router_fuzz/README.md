# NOC FUZZING

You need to compile 3 dictionary
- AFL_hardware
- afl_proxy
- router_simple

After all of them complied, run "python3 fuzz.py"

In fuzz.py, it launch AFL and use "mry-eda-vcs18" docker to run VCS HSB.