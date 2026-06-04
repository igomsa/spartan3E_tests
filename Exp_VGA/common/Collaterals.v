`timescale 1ns / 1ps
//------------------------------------------------
module UPCOUNTER_POSEDGE # (parameter SIZE=16)
(
input wire Clock, Reset,
input wire [SIZE-1:0] Initial,
input wire Enable,
output reg [SIZE-1:0] Q
);


  always @(posedge Clock )
  begin
      if (Reset)
        Q = Initial;
      else
		begin
		if (Enable)
			Q = Q + 1;

		end
  end

endmodule
//----------------------------------------------------
module FFD_POSEDGE_SYNCRONOUS_RESET # ( parameter SIZE=8 )
(
	input wire				Clock,
	input wire				Reset,
	input wire				Enable,
	input wire [SIZE-1:0]	D,
	output reg [SIZE-1:0]	Q
);


always @ (posedge Clock)
begin
	if ( Reset )
		Q <= 0;
	else
	begin
		if (Enable)
			Q <= D;
	end

end//always

endmodule


//----------------------------------------------------------------------
// adder module used to implement the array multiplier
module EMUL(
 input wire wA,
 input wire wB,
 input wire iCarry,
 output wire      oCarry,
 output wire      oR
);

     assign {oCarry,oR} = wA + wB + iCarry;
endmodule // EMUL

//----------------------------------------------------------------------
// 8-bit D flip-flop module used as an auxiliary register
// to avoid a sensitivity issue in the always@(*) of MiniAlu_E2.v.
module Buffer8b(
 input wire [15:0] iI,
 output reg [15:0] oO
);
   always @ (*)
   begin
      oO <= iI;
   end
endmodule //Buffer8b
