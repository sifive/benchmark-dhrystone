DHRY-LFLAGS =

DHRY-CFLAGS := -O3 -DTIME -DNOENUM -Wno-implicit -save-temps
DHRY-CFLAGS += -fno-builtin-printf -fno-common -falign-functions=4

#Uncomment below for FPGA run, default DHRY_ITERS is 2000 for RTL
#DHRY-CFLAGS += -DDHRY_ITERS=20000000

SRC = dhry_1.c dhry_2.c strcmp.S
OBJS = dhry_1.o dhry_2.o strcmp.o
HDR = dhry.h

ifeq ($(findstring rv32,$(RISCV_ARCH)),rv32)
RISCV_LD_EMULATION = elf32lriscv
else
RISCV_LD_EMULATION = elf64lriscv
endif

override CFLAGS += $(DHRY-CFLAGS) $(XCFLAGS) -Xlinker --defsym=__stack_size=0x800 -Xlinker --defsym=__heap_size=0x1000

# Perform an incremental link on object files to move .text sections into .itim so that benchmark code
# gets placed in Instruction Tightly-Integrated Memory (ITIM) if one exists.
%.o: $.o.unrenamed move-text-to-itim.lds
	$(LD) -i -m $(RISCV_LD_EMULATION) -T move-text-to-itim.lds $< -o $@

%.o.unrenamed: %.S $(HDR)
%.o.unrenamed: %.c $(HDR)
	$(CC) $(CFLAGS) -c $< -o $@.unrenamed

dhrystone: $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) $(LOADLIBES) $(LDLIBS) $^ -o $@

clean:
	rm -f *.i *.s *.o *.unrenamed dhrystone dhrystone.hex

