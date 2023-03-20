CC = riscv64-unknown-elf-gcc
DHRY-LFLAGS =

DHRY-CFLAGS := -O3 -DTIME -DNOENUM -Wno-implicit -save-temps -fno-inline
DHRY-CFLAGS += -fno-builtin-printf -fno-common -falign-functions=4

#Uncomment below for FPGA run, default DHRY_ITERS is 2000 for RTL
# 200,000,000 iterations should correspond to around 6-10 seconds for a P670 core.
# Given that sometimes Dhrystone measures time in tenths of a second, longer
# runs reduce the noise from poor clock granularity.
DHRY-CFLAGS += -DDHRY_ITERS=200000000

SRC = dhry_1.c dhry_2.c lib_a-strcmp.o
HDR = dhry.h

override CFLAGS += $(DHRY-CFLAGS) $(XCFLAGS) -Xlinker --defsym=__stack_size=0x800 -Xlinker --defsym=__heap_size=0x1000
dhrystone: $(SRC) $(HDR)
	$(CC) $(CFLAGS) $(SRC) $(LDFLAGS) $(LOADLIBES) $(LDLIBS) -o $@

clean:
	rm -f *.i *.s dhry*.o dhrystone dhrystone.hex

