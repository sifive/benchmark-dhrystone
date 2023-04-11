DHRY-CFLAGS := -O3 -DTIME -DNOENUM -Wno-implicit -save-temps
DHRY-CFLAGS += -fno-builtin-printf -fno-common -falign-functions=4

LDFLAGS := -Xlinker --defsym=__stack_size=0x800 -Xlinker --defsym=__heap_size=0x1000

#Uncomment below for FPGA run, default DHRY_ITERS is 2000 for RTL
#DHRY-CFLAGS += -DDHRY_ITERS=20000000

SRC = dhry_1.c dhry_2.c strcmp.S
OBJ = $(patsubst %.c,%.o,$(patsubst %.S,%.o,$(SRC)))
HDR = dhry.h

override CFLAGS += $(DHRY-CFLAGS) $(XCFLAGS)

dhrystone: $(OBJ)
	        $(CC) $(LDFLAGS) $(OBJ) -o $@

dhry_1.o: dhry_1.c $(HDR)
	        $(CC) $(CFLAGS) -c $< -o $@

dhry_2.o: dhry_2.c $(HDR)
	        $(CC) $(CFLAGS) -c $< -o $@

strcmp.o: strcmp.S $(HDR)
	        $(CC) $(CFLAGS) -c $< -o $@

clean:
	        rm -f *.i *.s *.o dhrystone dhrystone.hex
