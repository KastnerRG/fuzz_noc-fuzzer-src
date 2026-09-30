
all:
	make afl dut proxy

afl:
	make -C AFL_hardware

dut:
	make comp -C router_simple

proxy:
	make all -C afl_proxy




clean:
	make clean -C AFL_hardware
	make clean -C afl_proxy
	make cleanall -C router_simple
	rm -rf a2j j2a afl-log input
	rm -rf tb-output.txt sim.log
	rm -rf afl_result 