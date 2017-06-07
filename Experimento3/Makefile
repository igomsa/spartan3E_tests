Ejercicio_1:
	iverilog -Wall -o Ejercicio1.out LCD_Control.v LCD_Writer.v Writer_Enabler.v Collaterals.v Defintions.v testbench_LCD.v && vvp Ejercicio1.out && gtkwave Ejercicio1.vcd Ejercicio1.gtkw &


Ejercicio_2:
	iverilog -Wall -o Ejercicio2.out MiniAlu.v Module_ROM_E2.v Collaterals.v RAM.v Defintions.v TestBench.v && vvp Ejercicio2.out && gtkwave Ejercicio2.vcd Ejercicio2.gtkw &
clean_E1:
	rm Ejercicio1.out Ejercicio1.vcd
