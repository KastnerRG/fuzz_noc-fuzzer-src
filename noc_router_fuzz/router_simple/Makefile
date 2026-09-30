VCS_HOME=/usr/synopsys/vcs/O-2018.09-SP2
UVM_HOME=/usr/synopsys/vcs/O-2018.09-SP2/etc/uvm
plat=amd64

# COV_FLAG= 
# COV_FLAG= -cm line+cond+tgl+fsm+branch+assert
COV_FLAG= -cm line+branch
COMP_FLAG=+vc -sverilog ${UVM_HOME}/src/dpi/uvm_dpi.cc ${VCS_HOME}/${plat}/lib/libucapi.a -ldl -lm -lpthread -lstdc++ -CFLAGS -DVCS 

DOCKER=mry-eda-vcs18
DOCKER_CMD=docker exec ${DOCKER} bash -c
CMD_PLUS=source /etc/bashrc
CMD_PLUS+=; LD_PRELOAD=/usr/snpslmd-hack.so /usr/synopsys/scl/2018.06/linux64/bin/lmgrd -c /usr/synopsys/scl/2018.06/admin/license/Synopsys.dat -l /dev/null
CMD_PLUS+=; cd '${PWD}';

all:
	rm -f ../tb-output.txt
	touch ../tb-output.txt
	make comp sim gencov

comp:
	UVM_HOME=${UVM_HOME} vcs -full64 ${COV_FLAG} ${COMP_FLAG} -timescale=1ns/1ps -f filelist.f +plusarg_save +ntb_random_seed_automatic

sim:
	rm ../tb-output.txt
	touch ../tb-output.txt
	./simv ${COV_FLAG} >> ../tb-output.txt

sim-mry:
	${DOCKER_CMD} "${CMD_PLUS} ./simv ${COV_FLAG}"

gencov:
# urg -dir simv.vdb
	urg -dir simv.vdb -line nocasedef

clean:
	rm -f simv.daidir/.vcs.timestamp

cleanall:
	rm -rf csrc/ simv.daidir/ simv.vdb/ urgReport/
	rm -f simv tr_db.log ucli.key vc_hdrs.h cm.log output.txt simulation.log vcs.log