# Icarus Verilog simulation of the piano keyboard game.
#
#   make sim     build and run the game testbench
#   make clean   remove build artifacts
#
# Piano_Drawer2.v is the VGA + PS/2-keyboard top (module Module_VGA_Control);
# IO/ holds the VGA timing generator, the keyboard reader and a counter.

IVERILOG := iverilog -g2005 -I IO -I common
VVP      := vvp

.PHONY: sim clean

sim:
	$(IVERILOG) -o piano.out FSM/Piano_Drawer2.v IO/crvga_480x640.v IO/upcounter.v IO/kb.v common/TestBench_SM.v
	$(VVP) piano.out

clean:
	rm -f *.out *.vcd
