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
       0:   oInstruction = {`NOP, 24'd0};//espera de 15ms
       1:   oInstruction = {`STO, `R1, 16'd0};
       2:   oInstruction = {`STO, `R2, 16'd65000};
       3:   oInstruction = {`STO, `R3, 16'd1};
       4:   oInstruction = {`NOP, 24'd0};//espera de 15ms
       5:   oInstruction = {`ADD ,`R1,`R1,`R3};
       6:   oInstruction = {`BLE , 8'd5,`R1,`R2 };
       7:   oInstruction = {`NOP, 24'd0};//espera de 15ms
       8:   oInstruction = {`STO, `R1, 16'd0};
       9:   oInstruction = {`STO, `R2, 16'd65000};
       10:  oInstruction = {`ADD ,`R1,`R1,`R3};
       11:  oInstruction = {`BLE , 8'd10,`R1,`R2 };
       12:  oInstruction = {`NOP, 24'd0};//espera de 15ms
       13:  oInstruction = {`STO, `R1, 16'd0};
       14:  oInstruction = {`STO, `R2, 16'd57507};
       15:  oInstruction = {`ADD ,`R1,`R1,`R3};
       16:  oInstruction = {`BLE , 8'd15,`R1,`R2 };
       17: oInstruction = {`STO, `R0, 16'h3};
       18: oInstruction = {`NOP, 24'd0};//espera de 15ms
       19: oInstruction = {`SHL, `R0, `R0, 8'd4};
       20: oInstruction = {`NOP, 24'd0};//espera de 15ms
       21: oInstruction = {`STO, `R1, 16'd0};
       22: oInstruction = {`STO, `R2, 16'd3};
       23: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
       24: oInstruction = {`ADD ,`R1,`R1,`R3};
       25: oInstruction = {`BLE , 8'd21,`R1,`R2 };
       26: oInstruction = {`NOP, 24'd205000 };//espera de 4.1ms
       27: oInstruction = {`STO, `R1, 16'd0};
       28: oInstruction = {`STO, `R2, 16'd3};
       29: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
       30: oInstruction = {`ADD ,`R1,`R1,`R3};
       31: oInstruction = {`BLE , 8'd21,`R1,`R2 };
       32: oInstruction = {`NOP, 24'd5000 };//espera de 100us
       33: oInstruction = {`STO, `R1, 16'd0};
       34: oInstruction = {`STO, `R2, 16'd3};
       35: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
       36: oInstruction = {`ADD ,`R1,`R1,`R3};
       37: oInstruction = {`BLE , 8'd21,`R1,`R2 };
       38: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
       39: oInstruction = {`NOP, 24'd2000};//espera de 40us
       40: oInstruction = {`STO, `R0, 16'h2};
       41: oInstruction = {`SHL, `R0, `R0, 8'd4};
       42: oInstruction = {`LCD, 8'b0, `R0,8'b0};
       43: oInstruction = {`NOP, 24'd2000};//espera de 40us //terimna la inicializacion sigue display clear
       44: oInstruction = {`STO, `R0, 16'h28};
       45: oInstruction = {`LCD, 8'b0, `R0,8'b0};
       46: oInstruction = {`NOP, 24'd50};//espera 1us
       47: oInstruction = {`SHL, `R0, `R0, 16'd4 };
       48: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
       49: oInstruction = {`NOP, 24'd2000};//espea 40us
       50: oInstruction = {`STO, `R0, 16'h06};
       51: oInstruction = {`LCD, 8'b0 , `R0, 8'b0};
       52: oInstruction = {`NOP, 24'd50};//espera 1us
       53: oInstruction = {`SHL, `R0, `R0, 8'd4};
       54: oInstruction = {`LCD, 8'b0 , `R0, 8'b0};
       55: oInstruction = {`NOP, 24'd2000};//espea 40us
       56: oInstruction = {`STO, `R0, 16'h0C};
       57: oInstruction = {`LCD, 8'b0 , `R0, 8'b0};
       58: oInstruction = {`NOP, 24'd50};//espero 1us
       59: oInstruction = {`SHL, `R0, `R0, 8'd4};
       60: oInstruction = {`LCD, 8'b0 , `R0, 8'b0};
       61:  oInstruction = {`NOP, 24'd2000};//espea 40us
       62: oInstruction = {`STO, `R0, 16'h01};
       63: oInstruction = {`LCD, 8'b0 , `R0, 8'b0};
       64: oInstruction = {`NOP, 24'd50};//espero 1us
       65: oInstruction = {`SHL, `R0, `R0, 8'd4};
       66: oInstruction = {`LCD, 8'b0 , `R0, 8'b0};
       67: oInstruction = {`NOP, 24'd82000};//espero 4.64ms //inicia la escritura
       68: oInstruction = {`STO, `R0, `H};
       69: oInstruction = {`LCD, 8'b0, `R0, 8'b1};
       70: oInstruction = {`NOP, 24'd50};
       71: oInstruction = {`SHL, `R0, `R0, 8'd4};
       72: oInstruction = {`LCD, 8'b0, `R0, 8'b1};
       73: oInstruction = {`NOP, 24'd2000};
       74: oInstruction = { `JMP,  8'd0, 16'b0};

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
