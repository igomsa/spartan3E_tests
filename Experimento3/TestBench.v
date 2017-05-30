`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:   22:30:52 01/30/2011
// Design Name:   MiniAlu
// Module Name:   D:/Proyecto/RTL/Dev/MiniALU/TestBench.v
// Project Name:  MiniALU
// Target Device:
// Tool versions:
// Description:
//
// Verilog Test Fixture created by ISE for module: MiniAlu
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
////////////////////////////////////////////////////////////////////////////////

module TestBench;

	// Inputs
   reg Clock, Reset;


	// Outputs
   wire [7:0] oLDC;
   wire       oReadWrite, oRegisterSelect, oEnable;


	// Instantiate the Unit Under Test (UUT)
	MiniAlu uut (
		.Clock(Clock),
		.Reset(Reset),
		.oLed(oLCD),
                .oReadWrite(oReadWrite),
                .oRegisterSelect(oRegisterSelect),
                .oEnable(oEnable)
        );

// generates clock signal
	always #1 Clock = !Clock;

	initial begin
		// Initialize Inputs
		Clock = 0;
		Reset = 1;
		#2 Reset = 0;

		// reset module
		//#100
		//Reset = 1;
		//#100
		//Reset = 0;

		// Wait 22 ms
		#22000000

		// Excecutable in GTKWave.
		$dumpfile("Ejercicio1.vcd");
		$dumpvars();
		#650 $finish;


           // Add stimulus here

		$finish;
	end


endmodule
