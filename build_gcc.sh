#!/bin/bash
export PATH=/nfs/teams/sw/share/jenkins-sw/toolchain/toolchain-meta-next/weekly-test/llvm-sifive-dev/2023-09-22_110/toolsuite-linux/package/bin:$PATH
iter=100000000
#iter=300000000

make DHRY-ITER=$iter
