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
   reg Clock;
   reg Reset;
   wire wVGA_B;
   wire wVGA_G;
   wire wVGA_R;
   wire [15:0] wHorizontal_Sync;
   wire [15:0] wVertical_Sync;

   // Outputs

   // Instantiate the Unit Under Test (UUT)
   MiniAlu uut (
                .Clock(Clock),
                .Reset(Reset),
                .oVGA_B(wVGA_B),
                .oVGA_G(wVGA_G),
                .oVGA_R(wVGA_R),
                .oHorizontal_Sync(wHorizontal_Sync),
                .oVertical_Sync(wVertical_Sync)
                );

   always
     begin
        #5  Clock =  ! Clock;

     end

   initial begin
      // Initialize Inputs
      Clock = 0;
      Reset = 0;

      // Wait 100 ns for global reset to finish
      #100;
      Reset = 1;
      #50
        Reset = 0;

      // Excecutable in GTKWave.
      $dumpfile("Ejercicio1.vcd");
      $dumpvars();
      #650 $finish;


      // Add stimulus here

   end

endmodule
