PREFIX = riscv-none-embed-
CC = $(PREFIX)gcc
AS = $(PREFIX)as
CP = $(PREFIX)objcopy
AR = $(PREFIX)ar
SZ = $(PREFIX)size
OD = $(PREFIX)objdump
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S
C_SOURCES = csr.c
ASM_SOURCE = eclic.s
CFLAGS = -g -Os -march=rv32imac -mabi=ilp32 -mcmodel=medlow -msmall-data-limit=8 -mno-save-restore -fsigned-char -ffunction-sections -fdata-sections
ASFLAGS = -g -march=rv32imac -mabi=ilp32
OBJECTS = $(notdir $(C_SOURCES:.c=.o))
OBJECTS += $(notdir $(ASM_SOURCE:.s=.o))

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@

%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

librv4rs.a : $(OBJECTS)
	$(AR) r $@ $(OBJECTS)
	
all: librv4rs

clean:
	rm -f *.a
	rm -f *.o
