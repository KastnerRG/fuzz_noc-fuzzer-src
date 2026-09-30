import argparse
import os
import sys
import shutil


fuzz_time = 86400
afl_path = './AFL_hardware'
out_folder_run_path = './afl_result'
seeds_path = './afl_seeds'
afl_proxy_path = './afl_proxy'

os.environ['AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES'] = '1'
os.environ['AFL_SKIP_CPUFREQ'] = '1'


os.system('rm -f afl-log a2j j2a')
os.system('rm -f tb-output.txt')
os.system('touch tb-output.txt')
os.system('bash setup.sh')


# simulate DUT
# os.system('cd router_simple && make sim-mry  >> ../tb-output.txt &')
os.system('source /rshome/ruiyang.ma/snps-2018/docker/bin/eda.sh && cd noc_mesh33_sim && eda make sim  >> ../tb-output.txt &')

os.system('sleep 2s')

os.system('timeout {TIME_STRING}s {AFL_PATH}/afl-fuzz -d -i {SEEDS_PATH} -o {OUT_FOLDER_RUN} -f input \
            -- {AFL_PROXY_PATH}/afl-proxy a2j j2a afl-log &'.format(
        TIME_STRING=str(fuzz_time), AFL_PATH=afl_path, SEEDS_PATH=seeds_path, OUT_FOLDER_RUN=out_folder_run_path, AFL_PROXY_PATH=afl_proxy_path))




# AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1 AFL_SKIP_CPUFREQ=1 timeout 10s ./AFL_rtl_fuzz_lab/afl-fuzz -d -i ./afl_seeds -o ./afl_result -f input -- ./afl_proxy/afl-proxy a2j j2a log