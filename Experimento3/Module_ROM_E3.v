`timescale 1ns / 1ps
`include "Defintions.v"

`define LOOP1 8'd8
`define SUBROUTINE 8'd24

module ROM
(
	input  wire[15:0]  		iAddress,
	output reg [27:0] 		oInstruction
);
always @ ( iAddress )
begin
	case (iAddress)


//LOOP1:
	0: oInstruction = { `NOP , 24'd4000    	};
	1: oInstruction = { `STO ,`R0, `M};
	2: oInstruction = { `CALL, `SUBROUTINE, `iAddress};
	3: oInstruction = { `STO ,`R0, `a};
	4: oInstruction = { `CALL, `SUBROUTINE, `iAddress};


SUBROUTINE: oInstruction = {`LDC_INIT, 24'd0};
	25: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
	26: oInstruction = {`NOP, 24`b1005};
	27: oInstruction = {`SHL, `R0, `R0, 8'd4};
	28: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
	29: oInstruction = {`NOP, 24`b1005};
	30: oInstruction = {`RET, 24`b00};

	default:
		oInstruction = { `LED ,  24'b10101010 };		//NOP
	endcase
end

endmodule
