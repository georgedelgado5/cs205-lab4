# George Delgado
# gdelgado@pdx.edu
# Lab 4

CC = gcc
AS = nasm

DEBUG = -g3 -O0
ARCH = -m32
PIE = -no-pie -fno-pie
STACK = -z noexecstack
CFLAGS = $(ARCH) $(PIE) $(DEBUG) -Wall
LDFLAGS = $(ARCH) $(PIE) $(STACK)
ASFLAGS = -g -f elf32 -F dwarf
PERMS = og+r

PROG1 = part1
PROG2 = part2
PROG3 = part3
PROG4 = part4
PROGS = $(PROG1) $(PROG2) $(PROG3) $(PROG4)

# There are some special make variables
# $@ is the target filename
# $^ is the names of all the prerequisites
# $< is the name of the first dependency
# there are others, but these are the ones we will be using

all : $(PROGS)

$(PROG1): $(PROG1).o
	$(CC) $(LDFLAGS) -o $@ $^

$(PROG1).o: $(PROG1).asm
	$(AS) $(ASFLAGS) -l $(PROG1).lst $<
	chmod $(PERMS) $(PROG1).asm

$(PROG2): $(PROG2).o
	$(CC) $(LDFLAGS) -o $@ $^

$(PROG2).o: $(PROG2).asm
	$(AS) $(ASFLAGS) -l $(PROG2).lst $<
	chmod $(PERMS) $(PROG2).asm

$(PROG3): $(PROG3).o
	$(CC) $(LDFLAGS) -o $@ $^

$(PROG3).o: $(PROG3).asm
	$(AS) $(ASFLAGS) -l $(PROG3).lst $<
	chmod $(PERMS) $(PROG3).asm

$(PROG4): $(PROG4).o
	$(CC) $(LDFLAGS) -o $@ $^

$(PROG4).o: $(PROG4).asm
	$(AS) $(ASFLAGS) -l $(PROG4).lst $<
	chmod $(PERMS) $(PROG4).asm

.PHONY: clean ci git get tar

clean:
	rm -f $(PROGS) *.s *.o *.lst *~ \#*

TAR_FILE = ${LOGNAME}_Lab_4.tar.gz
tar: clean
	rm -f $(TAR_FILE)
	tar cvaf $(TAR_FILE) *.asm [Mm]akefile
	tar tvaf $(TAR_FILE)

git: 
	if [ ! -d .git ] ; then git init; fi
	git add *.asm ?akefile
	if git rev-parse --quiet --verify HEAD; then \
		echo "Enter commit message: "; \
		read msg; \
		git commit -m "$$msg"; \
	else \
		git commit -m "Initial commit"; \
	fi
