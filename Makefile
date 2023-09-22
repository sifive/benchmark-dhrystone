PREFIX=riscv64-unknown-linux-gnu
CC = $(PREFIX)-gcc
CLANG = $(PREFIX)-clang
DHRY-LFLAGS =

####DHRY-CFLAGS := -O3 -DMSC_CLOCK -DNOENUM -Wno-implicit -save-temps -fno-inline
#### replace -DMSC_CLOCK with -DTIME to avoid dhry_1.c:270:22: error: 'CLK_TCK' undeclared (first use in this function)
DHRY-CFLAGS := -O3 -DTIME -DNOENUM -Wno-implicit -save-temps -fno-inline
DHRY-CFLAGS += -mabi=lp64d -mcmodel=medlow -fno-pie -frecord-gcc-switches -ffunction-sections -fdata-sections -O3 -mexplicit-relocs -fno-builtin-printf -fno-common -mtune=sifive-8-series -falign-functions=4 -static
###DHRY-CFLAGS += -fno-builtin-printf -fno-common -falign-functions=4
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
# 10M for quick runs, since the check is commented out.
#DHRY-CFLAGS += -DDHRY_ITERS=10000000
#DHRY-CFLAGS += -DDHRY_ITERS=1000000000
DHRY-CFLAGS += -DDHRY_ITERS=300000000
LDFLAGS += -static

SRC = dhry_1.c dhry_2.c
STRCMP = lib_a-strcmp.o
HDR = dhry.h

# We want to build several variants:
# - gcc and llvm
override CFLAGS += $(DHRY-CFLAGS) $(XCFLAGS)
###ALL_TARGETS = dhrystone.gcc dhrystone.llvm dhrystone.gcc.nobitmanip dhrystone.llvm.nobitmanip
ALL_TARGETS = dhrystone.gcc dhrystone.gcc.nobitmanip
all: $(ALL_TARGETS)

dhrystone.gcc: $(SRC) $(HDR)
	$(CC) $(CFLAGS) $(SRC) $(LDFLAGS) $(STRCMP) -o $@
dhrystone.llvm: $(SRC) $(HDR)
	$(CLANG) $(CFLAGS) $(LLVM_CFLAGS) $(SRC) $(LDFLAGS) $(STRCMP) -o $@
# Also build without the optimized strcmp.
dhrystone.gcc.nobitmanip: $(SRC) $(HDR)
	$(CC) $(CFLAGS) $(SRC) $(LDFLAGS) -o $@
dhrystone.llvm.nobitmanip: $(SRC) $(HDR)
	$(CLANG) $(CFLAGS) $(LLVM_CFLAGS) $(SRC) $(LDFLAGS) -o $@

disasm: all
	riscv64-unknown-elf-objdump -d dhrystone.gcc > disasm.gcc
	riscv64-unknown-elf-objdump -d dhrystone.llvm > disasm.llvm

clean:
	rm -f *.i *.s dhry*.o dhrystone dhrystone.hex $(ALL_TARGETS)

