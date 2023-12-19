#!/bin/bash
export PATH=/nfs/teams/sw/share/jenkins-sw/toolchain/toolchain-meta-next/weekly-test/llvm-sifive-dev/2023-09-22_110/toolsuite-linux/package/bin:$PATH

# u74r
make clean && make XCFLAGS="-O3 -mcpu=sifive-u74r" && mv dhrystone.gcc dhrystone.u74r.gcc.o3.inline.noflto
make clean && make XCFLAGS="-O3 -mcpu=sifive-u74r -fno-inline" && mv dhrystone.gcc dhrystone.u74r.gcc.o3.noinline.noflto
make clean && make XCFLAGS="-O3 -mcpu=sifive-u74r -fno-inline -flto" && mv ./dhrystone.gcc dhrystone.u74r.gcc.o3.noinlin.flto
make clean && make XCFLAGS="-O3 -mcpu=sifive-u74r -flto" && mv ./dhrystone.gcc dhrystone.u74r.gcc.o3.inline.flto

# x280o
make clean && make XCFLAGS="-O3 -mcpu=sifive-x280o" && mv dhrystone.gcc dhrystone.x280o.gcc.o3.inline.noflto
make clean && make XCFLAGS="-O3 -mcpu=sifive-x280o -fno-inline" && mv dhrystone.gcc dhrystone.x280o.gcc.o3.noinline.noflto
make clean && make XCFLAGS="-O3 -mcpu=sifive-x280o -fno-inline -flto" && mv ./dhrystone.gcc dhrystone.x280o.gcc.o3.noinlin.flto
make clean && make XCFLAGS="-O3 -mcpu=sifive-x280o -flto" && mv ./dhrystone.gcc dhrystone.x280o.gcc.o3.inline.flto
