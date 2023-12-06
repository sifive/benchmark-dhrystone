#!/bin/bash

# wk110: 173xxx (3.03), the best we have today.
export PATH=/nfs/teams/sw/share/jenkins-sw/toolchain/toolchain-meta-next/weekly-test/llvm-sifive-dev/2023-09-22_110/toolsuite/package/bin:$PATH

# 2023.03.1: 164508 (2.88), this is what the best we have before.
#export PATH=/sifive/tools/freedom-tools/toolsuite/riscv64-unknown-elf-toolsuite-15.9.0-2023.03.1-x86_64-linux-redhat8/bin:$PATH

TOOLCHAIN_DIR=`echo $PATH |sed "s/.*toolsuite-.*-\(202.*\)-x86_64.*/\1/"`
iter=10000000
#iter=300000000

make DHRY-ITER=$iter
