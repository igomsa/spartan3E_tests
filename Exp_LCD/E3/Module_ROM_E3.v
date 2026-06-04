`timescale 1ns / 1ps
`include "Defintions.v"

`define LOOP1 8'd8
`define SUBROUTINE 8'd50

module ROM
(
	input  wire[15:0]  		iAddress,
	output reg [27:0] 		oInstruction
);
always @ ( iAddress )
begin
	case (iAddress)


//LOOP1:
	0: oInstruction = {`LCD_INIT, 24'd0};
//LCD_INIT:
	1: oInstruction = {`NOP, 24'd750000};//wait 15ms
	2: oInstruction = {`STO, `R0, 16'h3};
	3: oInstruction = {`SHL, `R0, `R0, 8'd4};
	4: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
	5: oInstruction = {`NOP, 24'd205000 };//wait 4.1ms
	6: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
	7: oInstruction = {`NOP, 24'd5000 };//wait 100us
	8: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
	9: oInstruction = {`NOP, 24'd2000};//wait 40us
	10: oInstruction = {`STO, `R0, 16'h2};
	11: oInstruction = {`SHL, `R0, `R0, 8`b4};
	12: oInstruction = {`LCD, 8'b0, `R0,8'b0};
	13: oInstruction = {`NOP, 24'd2000};//wait 40us
	//end of init, continue with display clear
	14: oInstruction = {`STO, `R0, 16'h28};
	15: oInstruction = {`LCD, 8'b0, `R0,8'b0};
	16: oInstruction = {`NOP, 24'd50};//wait 1us
	17: oInstruction = {`SHL, `R0, `R0, 16'd4 };
	18: oInstruction = {`LCD, 8'b0, `R0, 8'b0};
	19: oInstruction = {`NOP, 24'd2000};//wait 40us
	20: oInstruction = {`STO, `R0, 16'h06};
	21: oInstruction = {`LCD, 8'b0 , `R0, 8'b0};
	22: oInstruction = {`NOP, 24'd50};//wait 1us
	23: oInstruction = {`SHL, `R0, `R0, 8'd4};
	24: oInstruction = {`LCD, 8'b0 , `R0, 8'b0};
	25: oInstruction = {`NOP, 24'd2000};//wait 40us
	26: oInstruction = {`STO, `R0, 16'h0C};
	27: oInstruction = {`LCD, 8'b0 , `R0, 8'b0};
	28: oInstruction = {`NOP, 24'd50};//wait 1us
	29: oInstruction = {`SHL, `R0, `R0, 8'd4};
	30: oInstruction = {`LCD, 8'b0 , `R0, 8'b0};
	31: oInstruction = {`NOP, 24'd2000};//wait 40us
	32: oInstruction = {`STO, `R0, 16'h01};
	33: oInstruction = {`LCD, 8'b0 , `R0, 8'b0};
	34: oInstruction = {`NOP, 24'd50};//wait 1us
	35: oInstruction = {`SHL, `R0, `R0, 8'd4};
	36: oInstruction = {`LCD, 8'b0 , `R0, 8'b0};
	37: oInstruction = {`NOP, 24'd82000};//wait 4.64ms
 	38: oInstruction = { `STO, `R1, `M}; //Load the letter M
	39: oInstruction = { `CALL, `SUBROUTINE, iAddress}; //Call the subroutine
	40: oInstruction = { `JMP,  8'd0, 16'b0};

SUBROUTINE: oInstruction = {`LCD, 8'b0, `R1, 8'b0};
	51: oInstruction = {`NOP, 24'd1005};
	52: oInstruction = {`SHL, `R1, `R1, 8'd4};
	53: oInstruction = {`LCD, 8'b0, `R1, 8'b0};
	54: oInstruction = {`NOP, 24'd1005};
	55: oInstruction = {`RET, 24'b00};

	default:
		oInstruction = { `LED ,  24'b10101010 };		//NOP
	endcase
end

endmodule
