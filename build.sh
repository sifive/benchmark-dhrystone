#!/bin/bash
export PATH=/sifive/tools/freedom-tools/toolsuite-linux/riscv64-unknown-linux-gnu-toolsuite-15.9.0-2023.03.1-x86_64-linux-redhat8/bin:$PATH
#iter=1000000000
iter=300000000

make
mv dhrystone.gcc.nobitmanip swbi_dh_gcc_nobitmanip
mv dhrystone.gcc swbi_dh_gcc_$iter

make XCFLAGS="-mcpu=sifive-p470"
mv dhrystone.gcc.nobitmanip swbi_dh_gcc_nobitmanip_mcpu470
mv dhrystone.gcc swbi_dh_gcc_mcpu470_$iter

make XCFLAGS="-mcpu=sifive-p670"
mv dhrystone.gcc.nobitmanip swbi_dh_gcc_nobitmanip_mcpu670
mv dhrystone.gcc swbi_dh_gcc_mcpu670_$iter

