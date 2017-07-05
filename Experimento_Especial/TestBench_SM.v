`timescale 1ns / 1ps

module testbench_VGA;

   // Inputs
   reg Clock;
   reg Reset;
	reg rClock;
	reg rData;
	

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
		
	keyboard keyboard2(
		.clk_kb(Clock),
		.data_kb(rData)
	);
	 // generates clock signal
   always #1 Clock = !Clock;
  // reset module
   
	initial begin //11010101010
		Clock = 1;
		Reset = 1;
		rClock = 1;
		rData = 1;
		
		
	#20
		Reset = 0;
		
	#2
		rData = 0; //inicia bit 11
	
	#2
		rData = 0; //primer bit del byte
	
	#2
		rData = 1;
	
	#2
		rData = 0;
	
	#2
		rData = 0;
	
	#2
		rData = 0;
	
	#2
		rData = 1;
	
	#2
		rData = 0; 
	
	#2
		rData = 0; // ac'a termina la tecla
	
	#2
		rData = 1; // paridad 
	
	#2
		rData = 1; // termina el env'io
	
	#10
	#2
		rData = 0; //inicia bit 11
	
	#2
		rData = 0; //primer bit del byte
	
	#2
		rData = 0;
	
	#2
		rData = 0;
	
	#2
		rData = 0;
	
	#2
		rData = 1;
	
	#2
		rData = 1;
	
	#2
		rData = 1; 
	
	#2
		rData = 1; // ac'a termina la tecla
	
	#2
		rData = 1; // paridad 
	
	#2
		rData = 1; // termina el env'io
	
	#10
		
		$finish;
	
	end
		
  

endmodule
