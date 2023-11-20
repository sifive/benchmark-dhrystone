#!/bin/bash
export PATH=/sifive/tools/freedom-tools/toolsuite-linux/riscv64-unknown-linux-gnu-toolsuite-15.9.0-2023.03.1-x86_64-linux-redhat8/bin:$PATH
iter=100000000
#iter=300000000

make DHRY-ITER=$iter
