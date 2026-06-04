# Spartan-3E Verilog Experiments

A set of Verilog experiments built around a small custom CPU — **MiniAlu** — on the
Digilent Spartan-3E board. The CPU runs short ROM programs that drive on-board LEDs,
an HD44780 character LCD, a VGA display, and a PS/2-keyboard "piano" game. Every
experiment ships a self-contained testbench you can run with Icarus Verilog.

## Contents

1. [The MiniAlu CPU](#the-minialu-cpu)
2. [Layout](#layout)
3. [Requirements](#requirements)
4. [Build & simulate](#build--simulate)
5. [Notes](#notes)

## The MiniAlu CPU

MiniAlu is a small accumulator-style processor: a program **ROM**, a dual-read
**register RAM**, and a datapath, with 28-bit instruction words. The opcode set
(see each experiment's `Defintions.v`) covers `NOP`, `ADD`, `SUB`, `MUL`, `STO`
(store), `BLE` (branch if less-or-equal) and `JMP`, plus peripheral / extension
opcodes used by specific experiments (`LED`, `LCD`, `SHL`, `CALL`, `RET`).

## Layout

| Directory | What it does |
|-----------|--------------|
| `Exp_LED/`   | MiniAlu running small programs whose results appear on the LEDs (E1–E4). |
| `Exp_LCD/`   | Driving an HD44780 LCD: `E1` modular writer FSM, `E2` MiniAlu + ROM, `force_fsm` monolithic init FSM. |
| `Exp_VGA/`   | VGA signal generation: ROM-driven color and an FSM pattern generator, plus a reusable timing generator (`crvga`). |
| `Piano_game/`| A PS/2 keyboard + VGA "piano" game (`Piano_Drawer2` is the top). |

Each experiment directory keeps its exercise-specific sources alongside a `common/`
folder of shared modules (CPU, RAM, `Collaterals`, `Defintions`).

## Requirements

- [Icarus Verilog](http://iverilog.icarus.com/) (`iverilog`) — simulation
- [GTKWave](https://gtkwave.sourceforge.net/) — waveform viewing

The designs were originally synthesized for the Spartan-3E in Xilinx ISE (the `.ucf`
constraint files remain in each directory).

## Build & simulate

Each directory has a `Makefile`. Some examples:

```bash
cd Exp_LED   && make all           # run E1..E4
cd Exp_VGA   && make sim_rom        # or: make sim_fsm
cd Exp_LCD   && make sim_e1         # or: sim_e2, sim_force_fsm
cd Piano_game && make sim
```

Where a `wave_*` target exists (e.g. `make wave_E1`), it opens that run's `.vcd`
in GTKWave. `make clean` removes build artifacts.

## Notes

- The RTL was originally synthesized in Xilinx ISE; a few spots were adjusted so it
  also simulates cleanly under Icarus Verilog (mainly giving explicit widths to
  literals used inside concatenations).
- `Exp_LCD/E3` is an unfinished variant (its ROM references an undefined opcode) and
  is intentionally not built.
