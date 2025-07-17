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
//Se define el módulo de multiplicación para implementar el "array multiplier"
module EMUL(
 input wire [5:0] wA,
 input wire [7:0] wB,
 input wire iCarry,
 output wire       oCarry,
 output wire [7:0] oR
);

     assign oR = wA + wB;
endmodule // EMUL



// Modulo para multiplicacion con Mux
module MUX(
	input wire [5:0] wCase0,
	input wire [5:0] wCase1,
	input wire [5:0] wCase2,
	input wire [5:0] wCase3,
	input wire [1:0] wSelection,
	output reg[5:0] oR
);
	always @(*)
	begin
	if(wSelection == 2'b00)
		begin
      oR <= wCase0;
		end
	else if (wSelection == 2'b01)
		begin
     oR <= wCase1;
		end

	else if (wSelection == 2'b10)
		begin
      oR <= wCase2;
	  end

	else if (wSelection == 2'b11)
		begin
     oR <= wCase3;
	  end
	end
endmodule // MUX


