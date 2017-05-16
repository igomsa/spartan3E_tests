`timescale 1ns / 1ps

//state definitions
`define STATE_RESET 	 0
`define CUT_WORD 	 1
`define WRITE_1ST_NIBBLE 2
`define WAIT_1_uS 	 3
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

module Module_LCD_Writer(
        input wire        Reset,
        input wire [7:0]  iData_BYTE,
        input wire [79:0] iData_Phrase,
        input wire        wWrite_Phrase,
        input wire        Clock,
        output reg        oWrite_Phrase_Done,
        output wire [3:0] oSender,
        output reg        oEnable
   );

// Wire wEnable: Habilita la secuencia de escritura.
   wire wEnable;

// Reg [79:0] rData_NIBBLE:
   reg [79:0]  rData_NIBBLE;

// Reg [7:0] rCurrentState: Estado actual de la secuencia.
// Reg [7:0] rNextState: Siguiente en de la secuencia.
reg [7:0] rCurrentState,rNextState;

// Reg rTimeCountReset: En 1 pone cuenta en 0. En 0
// inicia la cuenta con el ciclo de reloj.
reg rTimeCountReset;

// Reg [31:0] rTimeCount: LLeva la cuenta de los ciclos de
// reloj que han pasado.
reg [31:0] rTimeCount;

// Wire wWrite_Reset: Inicia secuencia de Write_Enable
   wire    wWrite_Reset;

   Module_Write_Enable Write_Enable
(
 .iReset(),
 .Clock(),
 .oLCD_ReadWrite(),
 .oLCD_RegisterSelect(),
 .oLCD_Enabled(),
 .rEnableDone()
);


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
	begn
		if (rTimeCountReset)
				rTimeCount <= 32'b0; //restart count
                else
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
               rNextState <= `WAIT_1_uS;
            end
          //------------------------------------------
          `WAIT_1_uS 	:
            begin
               wWrite_Reset <= 0;
               oWrite_Phrase_Done <= 0;
               oSender <= rData_NIBBLE;
               rTimeCountReset <= 1'b0;
               if (rTimeCount <= 32'b51)
                 rNextState <= `RESET_COUNT_0;
               else
                 rNextState <= `WAIT_1_uS;
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
               rNextState <= `WAIT_40_uS;
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
                 rNextState <= `WAIT_40_uS;

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
