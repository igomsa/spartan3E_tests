`timescale 1ns / 1ps

//state definitions
`define STATE_RESET 			0
`define STATE_BEFORE_EN_H 	1
`define STATE_HOLD_EN_H 	2
`define STATE_AFTER_EN_H 	3
`define STATE_INTER 			4
`define STATE_BEFORE_EN_L 	5
`define STATE_HOLD_EN_L 	6
`define STATE_AFTER_EN_L 	7
`define STATE_FINISH_W 		8

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    11:56:50 09/21/2016
// Design Name:
// Module Name:    senderLCD
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module senderLCD(
	input wire iWriteEnabler,
	input wire [7:0] iData,
	input wire Reset,
	input wire Clock,
	output reg oWriteDone,
	output reg [3:0] oNIBBLE,
	output reg oLCD_EN
   );

reg [7:0] rCurrentState,rNextState;
reg rTimeCountReset;
reg [31:0] rTimeCount;

//----------------------------------------------
//Next State and delay logic
always @ ( posedge Clock )
begin
	if (Reset)
	begin
		rCurrentState <= `STATE_RESET;
		rTimeCount <= 32'b0;
	end
	else
	begin
		if (rTimeCountReset)
				rTimeCount <= 32'b0; //reset the counter
		else
				rTimeCount <= rTimeCount + 32'b1; //increment the counter

		rCurrentState <= rNextState;
	end
end

//----------------------------------------------
//Current state and output logic
always @ ( * )
begin
	case (rCurrentState)
	//-----------------------------------------
	//Stay in this state until writing is enabled.
	`STATE_RESET:
	begin
		oNIBBLE = 			4'b0;
		oWriteDone = 		1'b0;
		oLCD_EN = 			1'b0;
		rTimeCountReset = 1'b1;

		if(iWriteEnabler)
			rNextState = `STATE_BEFORE_EN_H;
		else
			rNextState = `STATE_RESET;
	end
	//------------------------------------------
	//Send the most significant nibble, EN=0
	`STATE_BEFORE_EN_H:
	begin
	        oNIBBLE = 		iData[7:4]; //most significant nibble
		oWriteDone = 		'b0;
		oLCD_EN = 			1'b0;			//E=0
		rTimeCountReset = 1'b0;

		//delay 40ns
		if (rTimeCount > 32'd2 )
		begin
			rTimeCountReset = 1'b1; //reset the counter
			rNextState = `STATE_HOLD_EN_H;
		end
		else
			rNextState = `STATE_BEFORE_EN_H;
	end
	//------------------------------------------
	//Hold the 4 most significant bits high, EN=1
	`STATE_HOLD_EN_H:
	begin
		oNIBBLE = 		iData[7:4]; //most significant nibble
		oWriteDone = 		1'b0;
		oLCD_EN = 			1'b1;			//E=1
		rTimeCountReset = 1'b0;

		//delay 240 ns
		if (rTimeCount > 32'd12 )
		begin
			rTimeCountReset = 1'b1; //reset the counter
			rNextState = `STATE_AFTER_EN_H;
		end
		else
			rNextState = `STATE_HOLD_EN_H;
	end
	//------------------------------------------
	//E=0, hold the upper nibble for 40ns
	`STATE_AFTER_EN_H:
	begin
		oNIBBLE = 		iData[7:4]; //most significant nibble
		oWriteDone = 		1'b0;
		oLCD_EN = 			1'b0;			//E=0
		rTimeCountReset = 1'b0;

		//delay 40ns
		if (rTimeCount > 32'd2 )
		begin
			rTimeCountReset = 1'b1; //reset the counter
			rNextState = `STATE_INTER;
		end
		else
			rNextState = `STATE_AFTER_EN_H;
	end

	//------------------------------------------
	//delay between the 6-bit transfers
	`STATE_INTER:
	begin
		oNIBBLE = 			4'b0;
		oWriteDone = 		1'b0;
		oLCD_EN = 			1'b0;
		rTimeCountReset = 1'b0;

		//delay 1us
		if (rTimeCount > 32'd50 )
		begin
			rTimeCountReset = 1'b1; //reset the counter
			rNextState = `STATE_BEFORE_EN_L;
		end
		else
			rNextState = `STATE_INTER;
	end

	//------------------------------------------
	//Enable the least significant nibble, E=0
	`STATE_BEFORE_EN_L:
	begin
		oNIBBLE = 		iData[3:0]; //least significant nibble
		oWriteDone = 		1'b0;
		oLCD_EN = 			1'b0;			//E=0
		rTimeCountReset = 1'b0;

		//delay 40ns
		if (rTimeCount > 32'd2 )
		begin
			rTimeCountReset = 1'b1; //reset the counter
			rNextState = `STATE_HOLD_EN_L;
		end
		else
			rNextState = `STATE_BEFORE_EN_L;
	end
	//------------------------------------------
	//Hold the least significant nibble high, E=1
	`STATE_HOLD_EN_L:
	begin
		oNIBBLE = 			iData[3:0]; //least significant nibble
		oWriteDone = 		1'b0;
		oLCD_EN = 			1'b1;			//E=1
		rTimeCountReset = 1'b0;

		//delay 240ns
		if (rTimeCount > 32'd12 )
		begin
			rTimeCountReset=1'b1; //reset the counter
			rNextState = `STATE_AFTER_EN_L;
		end
		else
			rNextState = `STATE_HOLD_EN_L;
	end
	//------------------------------------------
	// Hold the least significant nibble for 40ns, E=0
	`STATE_AFTER_EN_L:
	begin
		oNIBBLE = 		iData[3:0]; //least significant nibble
		oWriteDone = 		1'b0;
		oLCD_EN = 			1'b0;			//E=0
		rTimeCountReset = 1'b0;

		//delay 40ns
		if (rTimeCount > 32'd2 )
		begin
			rTimeCountReset = 1'b1; //reset the counter
			rNextState = `STATE_FINISH_W;
		end
		else
			rNextState = `STATE_AFTER_EN_L;
	end

	//------------------------------------------
	//40us delay between data
	`STATE_FINISH_W:
	begin
		oNIBBLE = 			4'b0;
		oWriteDone = 		1'b0;
		oLCD_EN = 			1'b0;
		rTimeCountReset = 1'b0;

		//delay 40us
		if (rTimeCount > 32'd2000 )
		begin
			rTimeCountReset = 1'b1;
			oWriteDone = 		1'b1;				//sets end signal
			rNextState = 		`STATE_RESET;
		end
		else
			rNextState = 		`STATE_FINISH_W;
	end

	//------------------------------------------
	default:
	begin
		oNIBBLE = 			4'b0;
		oWriteDone = 		1'b0;
		oLCD_EN = 			1'b0;
		rTimeCountReset = 1'b0;
		rNextState = 		`STATE_RESET;
	end

	endcase
end
endmodule
