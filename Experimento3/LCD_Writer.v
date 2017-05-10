`timescale 1ns / 1ps

//state definitions
`define STATE_RESET 	 0
`define CUT_WORD 	 1
`define WRITE_1ST_NIBBLE 2
`define WAIT_1uS 	 3
`define RESET_COUNT  	 4
`define WRITE_2ND_NIBBLE 5
`define WAIT_40_uS 	 6
`define RESET_COUNT  	 7

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
        input wire        iWriteBegin,
        input wire [7:0]  iData_BYTE,
        input wire [79:0] iData_Phrase,
        input wire        wEnable_Write_Phrase,
        input wire        wWrite_Phrase,
        input wire        Clock,
        output reg        oWrite_Phrase_Done,
        output wire [3:0] oSender,
        output reg        oEnable
   );

   wire wEnable, wWrite_Reset, Index;
   reg [3:0]  rData_NIBBLE;

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
				rTimeCount <= 32'b0; //restart count else
				rTimeCount <= rTimeCount + 32'b1; //increments count

		rCurrentState <= rNextState;
	end
end
always @ ( * )
     begin
        case (rCurrentState)
          //------------------------------------------
          `STATE_RESET 	:
            begin
               wWrite_Reset <= 1'b0;
               oWrite_Phrase_Done <= 1'b0;
               oSender <= 4'h0;
               rTimeCountReset <= 1'b1;
               if (iWriteBegin)
                 rNextState <= `WRITE_1ST_NIBBLE;
               else
                 rNextState <= `STATE_RESET;
            end
          //------------------------------------------
          `WRITE_1ST_NIBBLE:
            begin
               wWrite_Reset <= 1;
               oWrite_Phrase_Done <= 0;
               rTimeCountReset <= 1'b1;
               if (wWrite_Phrase)
                 rData_NIBBLE <= iData_Phrase[3:0];
               else
                 rData_NIBBLE <= iData_BYTE[3:0];
               rNextState <= `WAIT_1uS;
            end
          //------------------------------------------
          `WAIT_1uS 	:
            begin
               wWrite_Reset <= 0;
               oWrite_Phrase_Done <= 0;
               oSender <= rData_NIBBLE;
               rTimeCountReset <= 1'b0;
               if (rTimeCount <= 32'b51)
                 rNextState <= `RESET_COUNT_0;
               else
                 rNextState <= `WAIT_1uS;
            end
          //------------------------------------------
          `RESET_COUNT_0 	:
            begin
               wWrite_Reset <= 0;
               oWrite_Phrase_Done <= 0;
               oSender <= 4'h0;
               rTimeCountReset <= 1'b1;
               rNextState <= `WRITE_2ND_NIBBLE;
            end
          //------------------------------------------
          `WRITE_2ND_NIBBLE:
            begin
               wWrite_Reset <= 1;
               oWrite_Phrase_Done <= 0;
               rTimeCountReset <= 1'b1;
               if (wWrite_Phrase)
                 rData_NIBBLE <= iData_Phrase[3:0];
               else
                 rData_NIBBLE <= iData_BYTE[3:0];
               rNextState <= `WAIT_40uS;
            end
          //------------------------------------------
          `WAIT_40_uS 	:
            begin
               wWrite_Reset <= 0;
               oWrite_Phrase_Done <= 0;
               oSender <= rData_NIBBLE;
               rTimeCountReset <= 1'b0;
               if (rTimeCount <= 32'b200)
                 rNextState <= `RESET_COUNT_1;
               else
                 rNextState <= `WAIT_40uS;

            end
          //------------------------------------------
          `RESET_COUNT_1  	:
            begin
               wWrite_Reset <= 0;
               oWrite_Phrase_Done <= 0;
               oSender <= 4'h0;
               rTimeCountReset <= 1'b1;
               if (wWrite_Phrase)
               rNextState <= `CUT_WORD;
               else
               rNextState <= `RESET_STATE;
            end
          //------------------------------------------
          `CUT_WORD 	:
            begin
               wWrite_Reset <= 0;
               oWrite_Phrase_Done <= 0;
               oSender <= 4'h0;
               iData_Phrase <= iData_Phrase >> 8;
               rNextState <= `RESET_STATE;
            end
          //------------------------------------------
          default:
            begin
               rNextState <= `STATE_RESET;
            end
        endcase
end
endmodule
