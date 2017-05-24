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
 	//0: oInstruction = {`LCD_INIT, 24'd0};
 //LCD_INIT:
 	0: oInstruction = {`NOP, 24'd750000};//espera de 15ms
 	1: oInstruction = {`STO, `R0, 16'h3};
 	2: oInstruction = {`SHL, `R0, `R0, 8'd4};
 	3: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
 	4: oInstruction = {`NOP, 24'd205000 };//espera de 4.1ms
 	5: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
 	6: oInstruction = {`NOP, 24'd5000 };//espera de 100us
 	7: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
 	8: oInstruction = {`NOP, 24'd2000};//espera de 40us
 	9: oInstruction = {`STO, `R0, 16'h2};
 	10: oInstruction = {`SHL, `R0, `R0, 8`b4};
 	11: oInstruction = {`LCD, 8'b0, `R0,8'b0};
 	12: oInstruction = {`NOP, 24'd2000};//espera de 40us
 	//terimna la inicializacion sigue display clear
 	13: oInstruction = {`STO, `R0, 16'h28};
 	14: oInstruction = {`LCD, 8'b0, `R0,8'b0};
 	15: oInstruction = {`NOP, 24'd50};//espera 1us
 	16: oInstruction = {`SHL, `R0, `R0, 16'd4 };
 	17: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
 	18: oInstruction = {`NOP, 24'd2000};//espea 40us
 	19: oInstruction = {`STO, `R0, 16'h06};
 	20: oInstruction = {`LCD, 8'b0 , `R0, 8'b0};
 	21: oInstruction = {`NOP, 24'd50};//espera 1us
 	22: oInstruction = {`SHL, `R0, `R0, 8'd4};
 	23: oInstruction = {`LCD, 8'b0 , `R0, 8'b0};
 	24: oInstruction = {`NOP, 24'd2000};//espea 40us
 	25: oInstruction = {`STO, `R0, 16'h0C};
 	26: oInstruction = {`LCD, 8'b0 , `R0, 8'b0};
 	27: oInstruction = {`NOP, 24'd50};//espero 1us
 	28: oInstruction = {`SHL, `R0, `R0, 8'd4};
 	29: oInstruction = {`LCD, 8'b0 , `R0, 8'b0};
 	30: oInstruction = {`NOP, 24'd2000};//espea 40us
 	31: oInstruction = {`STO, `R0, 16'h01};
 	32: oInstruction = {`LCD, 8'b0 , `R0, 8'b0};
 	33: oInstruction = {`NOP, 24'd50};//espero 1us
 	34: oInstruction = {`SHL, `R0, `R0, 8'd4};
 	35: oInstruction = {`LCD, 8'b0 , `R0, 8'b0};
 	36: oInstruction = {`NOP, 24'd82000};//espero 4.64ms
//inicia la escritura  
 	37: oInstruction = {`STO, `R0, `H};
 	38: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
 	39: oInstruction = {`NOP, 24'd50};
	40: oInstruction = {`SHL, `R0, `R0, 8'd4};
 	41: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
	42: oInstruction = {`NOP, 24'd2000};
	/*
 	43: oInstruction = {`STO, `R0, `o};
 	44: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
 	45: oInstruction = {`NOP, 24'd50};
	46: oInstruction = {`SHL, `R0, `R0, 8'd4};
 	47: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
	48: oInstruction = {`NOP, 24'd2000};
	49: oInstruction = {`STO, `R0, `l};
 	50: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
 	51: oInstruction = {`NOP, 24'd50};
	52: oInstruction = {`SHL, `R0, `R0, 8'd4};
 	53: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
	54: oInstruction = {`NOP, 24'd2000};
	55: oInstruction = {`STO, `R0, `a};
 	56: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
 	57: oInstruction = {`NOP, 24'd50};
	58: oInstruction = {`SHL, `R0, `R0, 8'd4};
 	59: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
	60: oInstruction = {`NOP, 24'd2000};
	61: oInstruction = {`STO, `R0, `M};
 	62: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
 	63: oInstruction = {`NOP, 24'd50};
	64: oInstruction = {`SHL, `R0, `R0, 8'd4};
 	65: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
	66: oInstruction = {`NOP, 24'd2000};
	67: oInstruction = {`STO, `R0, `u};
 	68: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
 	69: oInstruction = {`NOP, 24'd50};
	70: oInstruction = {`SHL, `R0, `R0, 8'd4};
 	71: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
	72: oInstruction = {`NOP, 24'd2000};
	73: oInstruction = {`STO, `R0, `n};
 	74: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
 	75: oInstruction = {`NOP, 24'd50};
	76: oInstruction = {`SHL, `R0, `R0, 8'd4};
 	77: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
	78: oInstruction = {`NOP, 24'd2000};
	79: oInstruction = {`STO, `R0, `d};
 	80: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
 	81: oInstruction = {`NOP, 24'd50};
	82: oInstruction = {`SHL, `R0, `R0, 8'd4};
 	83: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
	84: oInstruction = {`NOP, 24'd2000};
	85: oInstruction = {`STO, `R0, `o};
	86: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
 	87: oInstruction = {`NOP, 24'd50};
	88: oInstruction = {`SHL, `R0, `R0, 8'd4};
 	89: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
	90: oInstruction = {`NOP, 24'd2000};
	*/
	43: oInstruction = { `JMP,  8'd0, 16'b0};
	default:
		oInstruction = { `LCD ,  24'b0 };		//NOP
	endcase


end


endmodule
