CC = riscv64-unknown-elf-gcc
CLANG = riscv64-unknown-elf-clang
DHRY-LFLAGS =

DHRY-CFLAGS := -O3 -DMSC_CLOCK -DNOENUM -Wno-implicit -save-temps -fno-inline
DHRY-CFLAGS += -fno-builtin-printf -fno-common -falign-functions=4
# This appears to hurt performance by a bit for now, so leave it out. In
# theory, this should help the compiler generate more
# conditional-move-optimization-friendly code.
#LLVM_CFLAGS := -mcpu=sifive-p650
#LLVM_CFLAGS := -mtune=p650

#Uncomment below for FPGA run, default DHRY_ITERS is 2000 for RTL
# 300,000,000 iterations should correspond to around 6-10 seconds for a P670 core.
# Given that sometimes Dhrystone measures time in tenths of a second, longer
# runs reduce the noise from poor clock granularity.
# But if we are using MSC_CLOCK, it should have pretty good granularity, so let's just run for 100M iterations, to avoid hitting the 2 second auto-detect issue.
DHRY-CFLAGS += -DDHRY_ITERS=10000
LDFLAGS += -static

SRC = dhry_1.c dhry_2.c gettime.c
STRCMP = lib_a-strcmp.o
VSTRCMP = libcrvv.a
VESTRCMP = strcmp-vexamp.o
HDR = dhry.h

# We want to build several variants:
# - gcc and llvm
override CFLAGS += $(DHRY-CFLAGS) $(XCFLAGS)
ALL_TARGETS = dhrystone.gcc dhrystone.llvm dhrystone.gcc.vext dhrystone.llvm.vext dhrystone.gcc.vexamp dhrystone.llvm.vexamp dhrystone.gcc.nobitmanip dhrystone.llvm.nobitmanip
all: $(ALL_TARGETS)

dhrystone.gcc: $(SRC) $(HDR)
	$(CC) $(CFLAGS) $(SRC) $(LDFLAGS) $(STRCMP) -o $@
dhrystone.llvm: $(SRC) $(HDR)
	$(CLANG) $(CFLAGS) $(LLVM_CFLAGS) $(SRC) $(LDFLAGS) $(STRCMP) -o $@

dhrystone.gcc.vext: $(SRC) $(HDR)
	$(CC) $(CFLAGS) $(SRC) $(LDFLAGS) $(VSTRCMP) -o $@
dhrystone.llvm.vext: $(SRC) $(HDR)
	$(CLANG) $(CFLAGS) $(LLVM_CFLAGS) $(SRC) $(LDFLAGS) $(VSTRCMP) -o $@

dhrystone.gcc.vexamp: $(SRC) $(HDR)
	$(CC) $(CFLAGS) $(SRC) $(LDFLAGS) $(VESTRCMP) -o $@
dhrystone.llvm.vexamp: $(SRC) $(HDR)
	$(CLANG) $(CFLAGS) $(LLVM_CFLAGS) $(SRC) $(LDFLAGS) $(VESTRCMP) -o $@

# Also build without the optimized strcmp.
dhrystone.gcc.nobitmanip: $(SRC) $(HDR)
	$(CC) $(CFLAGS) $(SRC) $(LDFLAGS) -o $@
dhrystone.llvm.nobitmanip: $(SRC) $(HDR)
	$(CLANG) $(CFLAGS) $(LLVM_CFLAGS) $(SRC) $(LDFLAGS) -o $@

disasm: all
	riscv64-unknown-elf-objdump -d dhrystone.gcc > disasm.gcc
	riscv64-unknown-elf-objdump -d dhrystone.llvm > disasm.llvm

clean:
	rm -f *.i *.s dhry*.o gettime.o dhrystone dhrystone.hex $(ALL_TARGETS)

