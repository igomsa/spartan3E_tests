# Self-checking testbench for the crvga VGA timing generator.
#
#   make sim    compile the design + testbench and run it
#               (exits non-zero if the testbench reports a mismatch)
#   make lint   static lint of the RTL
#   make wave   open the last run's waveform in GTKWave
#   make clean  remove build artifacts

RTL := ../common/crvga.v ../common/upcounter.v
TB  := crvga_tb.sv
TOP := crvga_tb
OUT := crvga_tb.out
VCD := crvga_tb.vcd

IVERILOG  ?= iverilog
VVP       ?= vvp
VERILATOR ?= verilator
GTKWAVE   ?= gtkwave

.PHONY: sim lint wave clean

sim: $(TB) $(RTL)
	$(IVERILOG) -g2012 -Wall -s $(TOP) -o $(OUT) $(RTL) $(TB)
	$(VVP) $(OUT) | tee sim.log
	@! grep -qi 'FAIL' sim.log

lint:
	$(VERILATOR) --lint-only -Wall $(RTL)

wave: $(VCD)
	$(GTKWAVE) $(VCD) &

clean:
	rm -f $(OUT) $(VCD) sim.log
