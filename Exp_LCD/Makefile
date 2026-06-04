# Icarus Verilog simulation of the HD44780 LCD experiments.
#
#   make sim_e1         modular LCD writer FSM (E1)
#   make sim_e2         MiniAlu driving the LCD via a ROM program (E2)
#   make sim_force_fsm  standalone monolithic LCD init FSM (force_fsm)
#   make wave_e1 / wave_e2   open the waveform in GTKWave
#   make all            run e1, e2 and force_fsm
#   make clean
#
# Note: E3 is an unfinished variant (its ROM references the undefined opcode
# `LCD_INIT and has other defects), so it is not built here.

IVERILOG := iverilog -g2005 -I common
VVP      := vvp
GTKWAVE  := gtkwave

.PHONY: all clean sim_e1 sim_e2 sim_force_fsm wave_e1 wave_e2

all: sim_e1 sim_e2 sim_force_fsm

sim_e1:
	$(IVERILOG) -I E1 -o e1.out E1/LCD_Control.v E1/LCD_Writer.v E1/Writer_Enabler.v common/Collaterals.v E1/testbench_LCD.v
	$(VVP) e1.out

sim_e2:
	$(IVERILOG) -I E2 -o e2.out common/MiniAlu.v E2/Module_ROM_E2.v common/Collaterals.v common/RAM.v common/TestBench.v
	$(VVP) e2.out

sim_force_fsm:
	iverilog -g2005 -I force_fsm -o force_fsm.out force_fsm/LCD.v force_fsm/senderLCD.v force_fsm/testbench_LCD.v
	$(VVP) force_fsm.out

wave_e1:
	$(GTKWAVE) Ejercicio1.vcd E1/Ejercicio1.gtkw &
wave_e2:
	$(GTKWAVE) Ejercicio2.vcd E2/Ejercicio2.gtkw &

clean:
	rm -f *.out *.vcd
