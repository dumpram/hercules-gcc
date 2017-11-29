################################################################################
# Makefile for Hercules TMS570LC43
#
# Author: Ivan Pavic (@dumpram)
################################################################################


PREFIX = arm-none-eabi-
CC = $(PREFIX)gcc
LD = $(PREFIX)ld
OBJCOPY = $(PREFIX)objcopy

CFLAGS   = -Wall -Werror -I include 
CFLAGS  += -mfpu=vfpv3-d16 -march=armv7-r -mcpu=cortex-r4f
CFLAGS  += -fomit-frame-pointer -fno-strict-aliasing -mbig-endian

LDFLAGS  = -EB --gc-sections

BINFLAGS = -O binary

SRCS  = $(wildcard source/*.c)
ASRCS = $(wildcard source/*.s)
OBJS  = $(patsubst %.c, %.o, $(SRCS))
AOBJS = $(patsubst %.s, %.o, $(ASRCS))
LINKER_SCRIPT = $(wildcard source/*.ld)

.SECONDARY:

all: app.bin Makefile

%.bin: %.elf
	$(OBJCOPY) $< $(BINFLAGS) $@

%.elf: $(OBJS) $(AOBJS)
	$(LD) $^ $(LDFLAGS) -o $@ -T $(LINKER_SCRIPT) 

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.s
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(AOBJS) app.elf app.bin
