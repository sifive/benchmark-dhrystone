DHRY-LFLAGS =

DHRY-CFLAGS := -O3 -DMSC_CLOCK -DNOENUM -Wno-implicit -fno-builtin-printf -fno-common -fno-inline

#Uncomment below for FPGA run, default DHRY_ITERS is 2000 for RTL
# 100M iterations for FPGA
DHRY-CFLAGS += -DDHRY_ITERS=100000000

STRCMP_WITH_BITMANIP ?= 1

LIB_STRCMP_SRC := strcmp.S
ifeq ($(STRCMP_WITH_BITMANIP), 1)
    LIB_STRCMP_SRC :=
    LDLIBS := lib/lib_a-strcmp.o
endif


SRC = dhry_1.c dhry_2.c $(LIB_STRCMP_SRC)
HDR = dhry.h

build: dhrystone

dhrystone: $(SRC) $(HDR)
	$(CC) $(DHRY-CFLAGS) $(CFLAGS) $(SRC) $(LDFLAGS) $(LOADLIBES) $(LDLIBS) -o $@

clean:
	rm -f *.i *.s *.o dhrystone dhrystone.hex
