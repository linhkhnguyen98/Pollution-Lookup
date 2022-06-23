# EXE - objects we want to build
# OBJS - objects we want to compile (from c)
# 
# We provide a phony target clean to rm all the .o files
# 
# Run make to run with warnings
# Run make WARN= to run without warnings
# Run make DEBUG= to run without debug
# Run make DEBUG= WARN= to run without debug and warnings
# Run make clean to clean objects

EXE = poll_lookup
OBJS = poll_lookup.o parse_opts.o strip_date.o print_info.o node_lookup.o 
CC = gcc
DEBUG = -g 
WARN = -Wall -Wextra
CFLAGS = -I. -std=gnu11 $(DEBUG) $(WARN) -L.
LIBS = -lhash

.PHONY: clean

AS = gcc
ASLIST = -Wa,-adhln
ASFLAGS = -I.

%.o : %.s
	$(AS) -c $(DEBUG) $(ASFLAGS) $< -o $@

$(EXE) : $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LIBS)

clean:
	rm -f $(EXE) $(OBJS)