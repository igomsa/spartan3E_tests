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

 	//espera de 15ms
       0:   oInstruction = {`STO, `R1, 16'd0};
       1:   oInstruction = {`STO, `R2, 16'd65536};
       2:   oInstruction = {`STO, `R3, 16'd1};
       3:   oInstruction = {`ADD ,`R1,`R1,`R3};
       4:   oInstruction = {`NOP, 24'd0};//espera de 15ms
       5:   oInstruction = {`BLE , 8'd4,`R1,`R2 };
       6:   oInstruction = {`STO, `R1, 16'd0};
       7:   oInstruction = {`STO, `R2, 16'd65536};
       8:   oInstruction = {`ADD ,`R1,`R1,`R3};
       9:   oInstruction = {`NOP, 24'd0};//espera de 15ms
       10:  oInstruction = {`BLE , 8'd4,`R1,`R2 };
       11: oInstruction = {`NOP, 24'd0};//espera de 15ms
       12: oInstruction = {`STO, `R0, 16'h3};
       13: oInstruction = {`NOP, 24'd0};//espera de 15ms
       14: oInstruction = {`SHL, `R0, `R0, 8'd4};
       15: oInstruction = {`NOP, 24'd0};//espera de 15ms
       16: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
       17: oInstruction = {`NOP, 24'd205000 };//espera de 4.1ms
       18: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
       19: oInstruction = {`NOP, 24'd5000 };//espera de 100us
       20: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
       21: oInstruction = {`NOP, 24'd2000};//espera de 40us
       22: oInstruction = {`STO, `R0, 16'h2};
       23:  oInstruction = {`SHL, `R0, `R0, 8'd4};
       24:  oInstruction = {`LCD, 8'b0, `R0,8'b0};
       25:  oInstruction = {`NOP, 24'd2000};//espera de 40us //terimna la inicializacion sigue display clear
       26:  oInstruction = {`STO, `R0, 16'h28};
       27:  oInstruction = {`LCD, 8'b0, `R0,8'b0};
       28:  oInstruction = {`NOP, 24'd50};//espera 1us
       29:  oInstruction = {`SHL, `R0, `R0, 16'd4 };
       30:  oInstruction = {`LCD, 8'b0, `R0, 8'b0};
       31:  oInstruction = {`NOP, 24'd2000};//espea 40us
       32:  oInstruction = {`STO, `R0, 16'h06};
       33:  oInstruction = {`LCD, 8'b0 , `R0, 8'b0};
       34:  oInstruction = {`NOP, 24'd50};//espera 1us
       35:  oInstruction = {`SHL, `R0, `R0, 8'd4};
       36:  oInstruction = {`LCD, 8'b0 , `R0, 8'b0};
       37:  oInstruction = {`NOP, 24'd2000};//espea 40us
       38:  oInstruction = {`STO, `R0, 16'h0C};
       39:  oInstruction = {`LCD, 8'b0 , `R0, 8'b0};
       40:  oInstruction = {`NOP, 24'd50};//espero 1us
       41:  oInstruction = {`SHL, `R0, `R0, 8'd4};
       42:  oInstruction = {`LCD, 8'b0 , `R0, 8'b0};
       43:  oInstruction = {`NOP, 24'd2000};//espea 40us
       44: oInstruction = {`STO, `R0, 16'h01};
       45: oInstruction = {`LCD, 8'b0 , `R0, 8'b0};
       46: oInstruction = {`NOP, 24'd50};//espero 1us
       47: oInstruction = {`SHL, `R0, `R0, 8'd4};
       48: oInstruction = {`LCD, 8'b0 , `R0, 8'b0};
       49: oInstruction = {`NOP, 24'd82000};//espero 4.64ms //inicia la escritura
       50: oInstruction = {`STO, `R0, `H};
       51: oInstruction = {`LCD, 8'b0, `R0, 8'b1};
       52: oInstruction = {`NOP, 24'd50};
       53: oInstruction = {`SHL, `R0, `R0, 8'd4};
       54: oInstruction = {`LCD, 8'b0, `R0, 8'b1};
       55: oInstruction = {`NOP, 24'd2000};
       56: oInstruction = { `JMP,  8'd0, 16'b0};

       default:
         oInstruction = { `LCD ,  24'b0 };		//NOP
        endcase


end


endmodule

/*
44: oInstruction = {`STO, `R0, `o};
 	45: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
 	46: oInstruction = {`NOP, 24'd50};
	47: oInstruction = {`SHL, `R0, `R0, 8'd4};
 	48: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
	49: oInstruction = {`NOP, 24'd2000};
	50: oInstruction = {`STO, `R0, `l};
 	51: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
 	52: oInstruction = {`NOP, 24'd50};
	53: oInstruction = {`SHL, `R0, `R0, 8'd4};
 	54: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
	55: oInstruction = {`NOP, 24'd2000};
	56: oInstruction = {`STO, `R0, `a};
 	57: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
 	58: oInstruction = {`NOP, 24'd50};
	59: oInstruction = {`SHL, `R0, `R0, 8'd4};
 	60: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
	61: oInstruction = {`NOP, 24'd2000};
	62: oInstruction = {`STO, `R0, `M};
 	63: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
 	64: oInstruction = {`NOP, 24'd50};
	65: oInstruction = {`SHL, `R0, `R0, 8'd4};
 	66: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
	67: oInstruction = {`NOP, 24'd2000};
	68: oInstruction = {`STO, `R0, `u};
 	69: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
 	70: oInstruction = {`NOP, 24'd50};
	71: oInstruction = {`SHL, `R0, `R0, 8'd4};
 	72: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
	73: oInstruction = {`NOP, 24'd2000};
	74: oInstruction = {`STO, `R0, `n};
 	75: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
 	76: oInstruction = {`NOP, 24'd50};
	77: oInstruction = {`SHL, `R0, `R0, 8'd4};
 	78: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
	79: oInstruction = {`NOP, 24'd2000};
	80: oInstruction = {`STO, `R0, `d};
 	81: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
 	82: oInstruction = {`NOP, 24'd50};
	83: oInstruction = {`SHL, `R0, `R0, 8'd4};
 	84: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
	85: oInstruction = {`NOP, 24'd2000};
	86: oInstruction = {`STO, `R0, `o};
	87: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
 	88: oInstruction = {`NOP, 24'd50};
	89: oInstruction = {`SHL, `R0, `R0, 8'd4};
 	90: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
	91: oInstruction = {`NOP, 24'd2000}; */
