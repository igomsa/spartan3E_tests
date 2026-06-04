# Icarus Verilog simulation of the VGA experiments.
#
#   make sim_rom    ROM-driven color generator (MiniAlu writes the VGA RAM)
#   make sim_fsm    FSM-driven VGA pattern generator
#   make wave       open the last run's waveform in GTKWave
#   make all        run both
#   make clean      remove build artifacts
#
# Each dir ships two resolution variants of a module (crvga / crvga_480x640,
# VGA_SM / VGA_SM_480x640) that declare the same name, so a build must pick ONE.
# Files are therefore listed explicitly rather than globbed.

IVERILOG := iverilog -g2005 -I common
VVP      := vvp
GTKWAVE  := gtkwave
VGA      := common/crvga.v common/upcounter.v common/Collaterals.v

.PHONY: all clean sim_rom sim_fsm wave

all: sim_rom sim_fsm

sim_rom:
	$(IVERILOG) -I ROM -o rom.out ROM/MiniAlu.v ROM/Module_ROM.v ROM/RAM.v ROM/RAM1.v $(VGA) ROM/TestBench.v
	$(VVP) rom.out

sim_fsm:
	$(IVERILOG) -I FSM -o fsm.out FSM/VGA_SM.v $(VGA) FSM/TestBench_SM.v
	$(VVP) fsm.out

wave:
	$(GTKWAVE) Ejercicio1.vcd &

clean:
	rm -f *.out *.vcd
