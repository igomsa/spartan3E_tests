`timescale 1ns / 1ps
`include "Defintions.v"

`define LOOP1 8'd8
`define LOOP2 8'd5
module ROM
(
	input  wire[15:0]  		iAddress,
	output reg [27:0] 		oInstruction
);
always @ ( iAddress )
begin
	case (iAddress)

//LOOP1:
 	0: oInstruction = {`LDC_INIT, 24'd0}
 	1: oInstruction = {`STO, `R0, `H}
 	2: oInstruction = {`LCD, 4'b0, `R0, 8'b0}
 	3: oInstruction = {`NOP, 24`b1005}
 	4: oInstruction = {`SHL, `R0, `R0, 8'b4}
 	5: oInstruction = {`LCD, 4'b0, `R0, 8'b0}
 	6: oInstruction = {`STO, `R0, `o}
 	7: oInstruction = {`LCD, 4'b0, `R0, 8'b0}
 	8: oInstruction = {`NOP, 24`b1005}
 	9: oInstruction = {`SHL, `R0, `R0, 8'b4}
 	10: oInstruction = {`LCD, 4'b0, `R0, 8'b0}
	11: oInstruction = {`STO, `R0, `l}
 	12: oInstruction = {`LCD, 4'b0, `R0, 8'b0}
 	13: oInstruction = {`NOP, 24`b1005}
 	14: oInstruction = {`SHL, `R0, `R0, 8'b4}
 	15: oInstruction = {`LCD, 4'b0, `R0, 8'b0}
	16: oInstruction = {`STO, `R0, `a}
 	17: oInstruction = {`LCD, 4'b0, `R0, 8'b0}
 	18: oInstruction = {`NOP, 24`b1005}
 	19: oInstruction = {`SHL, `R0, `R0, 8'b4}
 	20: oInstruction = {`LCD, 4'b0, `R0, 8'b0}
	21: oInstruction = {`STO, `R0, `M}
 	22: oInstruction = {`LCD, 4'b0, `R0, 8'b0}
 	23: oInstruction = {`NOP, 24`b1005}
 	24: oInstruction = {`SHL, `R0, `R0, 8'b4}
 	25: oInstruction = {`LCD, 4'b0, `R0, 8'b0}
	26: oInstruction = {`STO, `R0, `u}
 	27: oInstruction = {`LCD, 4'b0, `R0, 8'b0}
 	28: oInstruction = {`NOP, 24`b1005}
 	29: oInstruction = {`SHL, `R0, `R0, 8'b4}
 	30: oInstruction = {`LCD, 4'b0, `R0, 8'b0}
	31: oInstruction = {`STO, `R0, `n}
 	32: oInstruction = {`LCD, 4'b0, `R0, 8'b0}
 	33: oInstruction = {`NOP, 24`b1005}
 	34: oInstruction = {`SHL, `R0, `R0, 8'b4}
 	35: oInstruction = {`LCD, 4'b0, `R0, 8'b0}
	36: oInstruction = {`STO, `R0, `d}
 	37: oInstruction = {`LCD, 4'b0, `R0, 8'b0}
 	38: oInstruction = {`NOP, 24`b1005}
 	39: oInstruction = {`SHL, `R0, `R0, 8'b4}
 	40: oInstruction = {`LCD, 4'b0, `R0, 8'b0}
	41: oInstruction = {`STO, `R0, `o}
	42: oInstruction = { `JMP,  8'd0, 16'b0}
	default:
		oInstruction = { `LED ,  24'b10101010 };		//NOP
	endcase
end

endmodule
