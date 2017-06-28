`timescale 1ns / 1ps

module testbench_VGA;

   // Inputs
   reg Clock;
   reg Reset;

   // Outputs
   wire oVGA_B;
   wire oVGA_G;
   wire oVGA_R;
   wire oHorizontal_Sync;
   wire oVertical_Sync;


   // Instantiate the Unit Under Test (UUT)
   Module_VGA_Control uut
     (
      .Clock(Clock),
      .Reset(Reset),
      .oVGA_B(oVGA_B),
      .oVGA_G(oVGA_G),
      .oVGA_R(oVGA_R),
      .oHorizontal_Sync(oHorizontal_Sync),
      .oVertical_Sync(oVertical_Sync)
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
