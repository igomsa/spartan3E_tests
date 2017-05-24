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
 	2: oInstruction = {`LCD, 8'b0, `R0, 8'b0}
 	3: oInstruction = {`NOP, 24`b1005}
	4: oInstruction = {`SHL, `R0, `R0, 8'd4}
 	5: oInstruction = {`LCD, 8'b0, `R0, 8'b0}
	6: oInstruction = {`NOP, 24`b1005}
 	7: oInstruction = {`STO, `R0, `o}
 	8: oInstruction = {`LCD, 8'b0, `R0, 8'b0}
 	9: oInstruction = {`NOP, 24`b1005}
	10: oInstruction = {`SHL, `R0, `R0, 8'd4}
 	11: oInstruction = {`LCD, 8'b0, `R0, 8'b0}
	12: oInstruction = {`NOP, 24`b1005}
	13: oInstruction = {`STO, `R0, `l}
 	14: oInstruction = {`LCD, 8'b0, `R0, 8'b0}
 	15: oInstruction = {`NOP, 24`b1005}
	16: oInstruction = {`SHL, `R0, `R0, 8'd4}
 	17: oInstruction = {`LCD, 8'b0, `R0, 8'b0}
	18: oInstruction = {`NOP, 24`b1005}
	19: oInstruction = {`STO, `R0, `a}
 	20: oInstruction = {`LCD, 8'b0, `R0, 8'b0}
 	21: oInstruction = {`NOP, 24`b1005}
	22: oInstruction = {`SHL, `R0, `R0, 8'd4}
 	23: oInstruction = {`LCD, 8'b0, `R0, 8'b0}
	24: oInstruction = {`NOP, 24`b1005}
	25: oInstruction = {`STO, `R0, `M}
 	26: oInstruction = {`LCD, 8'b0, `R0, 8'b0}
 	27: oInstruction = {`NOP, 24`b1005}
	28: oInstruction = {`SHL, `R0, `R0, 8'd4}
 	29: oInstruction = {`LCD, 8'b0, `R0, 8'b0}
	30: oInstruction = {`NOP, 24`b1005}
	31: oInstruction = {`STO, `R0, `u}
 	32: oInstruction = {`LCD, 8'b0, `R0, 8'b0}
 	33: oInstruction = {`NOP, 24`b1005}
	34: oInstruction = {`SHL, `R0, `R0, 8'd4}
 	35: oInstruction = {`LCD, 8'b0, `R0, 8'b0}
	36: oInstruction = {`NOP, 24`b1005}
	37: oInstruction = {`STO, `R0, `n}
 	38: oInstruction = {`LCD, 8'b0, `R0, 8'b0}
 	39: oInstruction = {`NOP, 24`b1005}
	40: oInstruction = {`SHL, `R0, `R0, 8'd4}
 	41: oInstruction = {`LCD, 8'b0, `R0, 8'b0}
	42: oInstruction = {`NOP, 24`b1005}
	43: oInstruction = {`STO, `R0, `d}
 	44: oInstruction = {`LCD, 8'b0, `R0, 8'b0}
 	45: oInstruction = {`NOP, 24`b1005}
	46: oInstruction = {`SHL, `R0, `R0, 8'd4}
 	47: oInstruction = {`LCD, 8'b0, `R0, 8'b0}
	48: oInstruction = {`NOP, 24`b1005}
	49: oInstruction = {`STO, `R0, `o}
	50: oInstruction = {`LCD, 8'b0, `R0, 8'b0}
 	51: oInstruction = {`NOP, 24`b1005}
	52: oInstruction = {`SHL, `R0, `R0, 8'd4}
 	53: oInstruction = {`LCD, 8'b0, `R0, 8'b0}
	54: oInstruction = {`NOP, 24`b1005}
	55: oInstruction = { `JMP,  8'd0, 16'b0}
	default:
		oInstruction = { `LCD ,  24'b0 };		//NOP
	endcase
end

endmodule
