//state definitions
`define STATE_RESET 	 0
`define WRITE_1ST_NIBBLE 1
`define WAIT_1_uS 	 2
`define RESET_COUNT_0  	 3
`define WRITE_2ND_NIBBLE 4
`define WAIT_40_uS 	 5
`define RESET_COUNT_1  	 6
`define CUT_WORD 	 7
`define WRITE_DONE       8

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
        input wire [3:0]  iData_NIBBLE,
        input wire [7:0]  iData_BYTE,
        input wire [79:0] iData_Phrase,
        input wire [1:0]  wWrite_Phrase,
        input wire        Clock,
        output reg        oWrite_Phrase_Done,
        output reg [3:0]  oSender,
        output wire       oEnable
   );

// Reg [7:0] rCurrentState: Estado actual de la secuencia.
// Reg [7:0] rNextState: Siguiente en de la secuencia.
reg [7:0] rCurrentState,rNextState;

// Reg rTimeCountReset: En 1 pone cuenta en 0. En 0
// inicia la cuenta con el ciclo de reloj.
reg rTimeCountReset;

// Reg [31:0] rTimeCount: LLeva la cuenta de los ciclos de
// reloj que han pasado.
reg [31:0] rTimeCount;

   // Wire wEnableDone: Respuesta de Writer_Enabler.
   wire   wEnableDone;

// Register rWrite_Reset: Inicia secuencia de Write_Enable
   reg     rWrite_Reset;

// Register rData_Phrase: Frase de datos a escribir.
   reg [79:0] rData_Phrase, rAux;




   Module_Write_Enable Write_Enable
(
 .Reset(rWrite_Reset),
 .Clock(Clock),
 .oLCD_Enabled(oEnable),
 .rEnableDone(wEnableDone)
);

//   assign  = wLCD_Enable;

   initial begin
      oSender = 4'b0;
      rAux = 80'b0;
   end

//----------------------------------------------
//Next State and delay logic
always @ ( posedge Clock )
begin
	if (!Reset)
	begin
		rCurrentState <= `STATE_RESET;
		rTimeCount <= 32'b0;
	end
	else
	begin
		if (rTimeCountReset)
				rTimeCount <= 32'b0; //restart count
                else
                  rTimeCount <= rTimeCount + 32'b1; //increments count

		rCurrentState <= rNextState;
	end
end

//----------------------------------------------
always @ ( * )
     begin
        case (rCurrentState)
          //------------------------------------------
          `STATE_RESET 	:
            begin
               rWrite_Reset <= 1'b1;
               rData_Phrase <= 1'd0;
               oWrite_Phrase_Done <= 1'b0;
               oSender <= 1'd0;
               //oSender <= 4'b0;
               rTimeCountReset <= 1'b1;
                 rNextState <= `WRITE_1ST_NIBBLE;
            end
          //------------------------------------------
          `WRITE_1ST_NIBBLE:
            begin
               rWrite_Reset <= 0;
               oWrite_Phrase_Done <= 0;
               rTimeCountReset <= 1'b1;

               if (wWrite_Phrase == 2'd0)
                  begin
                     oSender <= iData_NIBBLE;
                     if (wEnableDone == 1'd1)
                       rNextState <= `WRITE_DONE;
                     else
                       rNextState <= `WRITE_1ST_NIBBLE;
                  end
               else if(wWrite_Phrase == 2'd1)
                 begin
                    oSender <= iData_BYTE[7:4];
                     if (wEnableDone == 1'd1)
                       rNextState <= `WAIT_1_uS;
                     else
                       rNextState <= `WRITE_1ST_NIBBLE;
                  end
               else if (wWrite_Phrase == 2'd2)
                 begin
                    oSender <= iData_Phrase[7:4];
                    if (wEnableDone == 1'd1)
                      rNextState <= `WAIT_1_uS;
                    else
                      rNextState <= `WRITE_1ST_NIBBLE;
                 end
               else
                 rNextState <= `WRITE_1ST_NIBBLE;
            end
          //------------------------------------------
          `WAIT_1_uS 	:
            begin
               rWrite_Reset <= 1;
               oWrite_Phrase_Done <= 0;
               oSender <= 1'd0;
               rTimeCountReset <= 1'b0;
               if (rTimeCount > 32'd53)
                 rNextState <= `RESET_COUNT_0;
               else
                 rNextState <= `WAIT_1_uS;
            end
          //------------------------------------------
          `RESET_COUNT_0 	:
            begin
               rWrite_Reset <= 1;
               oWrite_Phrase_Done <= 0;
               oSender <= oSender;
               rTimeCountReset <= 1'b1;
               rNextState <= `WRITE_2ND_NIBBLE;
            end
          //------------------------------------------
          `WRITE_2ND_NIBBLE:
begin
               rWrite_Reset <= 0;
               oWrite_Phrase_Done <= 0;
               rTimeCountReset <= 1'b1;

               if(wWrite_Phrase == 2'd1)
                 begin
                    oSender <= iData_BYTE[3:0];
                     if (wEnableDone == 1'd1)
                       rNextState <= `WAIT_40_uS;
                     else
                       rNextState <= `WRITE_2ND_NIBBLE;
                  end
               else if (wWrite_Phrase == 2'd2)
                 begin
                    oSender <= iData_Phrase[3:0];
                    if (wEnableDone == 1'd1)
                      rNextState <= `WAIT_40_uS;
                    else
                      rNextState <= `WRITE_2ND_NIBBLE;
                 end
               else
                 rNextState <= `WRITE_2ND_NIBBLE;
            end
          //------------------------------------------
          `WAIT_40_uS 	:
            begin
               rWrite_Reset <= 1;
               oWrite_Phrase_Done <= 0;
               oSender <= 1'd0;
               rTimeCountReset <= 1'b0;
               if (rTimeCount > 32'd2006)
                 rNextState <= `RESET_COUNT_1;
               else
                 rNextState <= `WAIT_40_uS;

            end
          //------------------------------------------
          `RESET_COUNT_1  	:
            begin
               rWrite_Reset <= 1;
               oWrite_Phrase_Done <= 0;
               oSender <= oSender;
               rTimeCountReset <= 1'b1;
               if (wWrite_Phrase==2)
               rNextState <= `CUT_WORD;
               else
               rNextState <= `WRITE_DONE;
            end
          //------------------------------------------
          `CUT_WORD 	:
            begin
               rWrite_Reset <= 1;
               oWrite_Phrase_Done <= 0;
               oSender <= oSender;
               rData_Phrase <= rData_Phrase >> 8;
               if (rData_Phrase == 0)
                 rNextState <= `WRITE_DONE;
               else
                 rNextState <= `STATE_RESET;
            end
          //------------------------------------------
          `WRITE_DONE 	:
            begin
               rWrite_Reset <= 1;
               oWrite_Phrase_Done <= 1;
               oSender <= oSender;
               rNextState <= `STATE_RESET;
            end
          //------------------------------------------
          default:
            begin
               rNextState <= `STATE_RESET;
            end
        endcase
end
endmodule
