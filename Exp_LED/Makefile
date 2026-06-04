# Icarus Verilog simulation of the MiniAlu LED experiments.
#
#   make sim_E1     build and run exercise 1 (writes Ejercicio1.vcd)
#   make wave_E1    open the exercise 1 waveform in GTKWave
#   make all        run every exercise
#   make clean      remove build artifacts
#
# Each MiniAlu_E*.v includes Defintions.v from common/, so -I points there.

IVERILOG := iverilog -g2005 -I common
VVP      := vvp
GTKWAVE  := gtkwave
COMMON   := common/Collaterals.v common/RAM.v

.PHONY: all clean \
        sim_E1 sim_E2 sim_E3 sim_E4 \
        wave_E1 wave_E2 wave_E3 wave_E4

all: sim_E1 sim_E2 sim_E3 sim_E4

sim_E1:
	$(IVERILOG) -I E1 -o Ejercicio1.out E1/MiniAlu_E1.v E1/Module_ROM_E1.v $(COMMON) E1/TestBench_E1.v
	$(VVP) Ejercicio1.out

sim_E2:
	$(IVERILOG) -I E2 -o Ejercicio2.out E2/MiniAlu_E2.v E2/Module_ROM_E2.v $(COMMON) E2/TestBench_E2.v
	$(VVP) Ejercicio2.out

sim_E3:
	$(IVERILOG) -I E3 -o Ejercicio3.out E3/MiniAlu_E3.v E3/Module_ROM_E3.v $(COMMON) E3/TestBench_E3.v
	$(VVP) Ejercicio3.out

# E4 has its own Collaterals_4.v (not the shared common/Collaterals.v).
sim_E4:
	$(IVERILOG) -I E4 -o Ejercicio4.out E4/MiniAlu_E4.v E4/Module_ROM_E4.v E4/Collaterals_4.v common/RAM.v E4/TestBench_E4.v
	$(VVP) Ejercicio4.out

wave_E1:
	$(GTKWAVE) Ejercicio1.vcd E1/Ejercicio1.gtkw &
wave_E2:
	$(GTKWAVE) Ejercicio2.vcd E2/Ejercicio2.gtkw &
wave_E3:
	$(GTKWAVE) Ejercicio3.vcd E3/Ejercicio3.gtkw &
wave_E4:
	$(GTKWAVE) Ejercicio4.vcd E4/Ejercicio4.gtkw &

clean:
	rm -f *.out *.vcd
