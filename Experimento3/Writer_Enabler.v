`timescale 1ns / 1ps
`define STATE_RESET     0
`define STATE_ENAB 	1
`define RESET_COUNT_0  	2
`define SET_UP_ENAB	3
`define RESET_COUNT_1  	4
`define SET_DOWN_ENAB	5
`define RESET_COUNT_2   6
`define	WRITE_DONE	7

module Module_Write_Enable
  (
   input wire  Reset,
   input wire  Clock,
   output reg oLCD_Enabled,
   output reg  rEnableDone
   );


// Reg [7:0] rCurrentState: Estado actual de la secuencia.
// Reg [7:0] rNextState: Siguiente en de la secuencia.
reg [7:0] rCurrentState,rNextState;

   // Reg rTimeCountReset: En 1 pone cuenta en 0. En 0
   // inicia la cuenta con el ciclo de reloj.
   reg         rTimeCountReset;

   // Reg [31:0] rTimeCount: LLeva la cuenta de los ciclos de
   // reloj que han pasado.
   reg [31:0]  rTimeCount;

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
               rTimeCount <= 32'b0; //restart count
             else
               rTimeCount <= rTimeCount + 32'b1; //increments count
             rCurrentState <= rNextState;
          end
     end

   always @( * )
     begin
        case(rCurrentState)
          //---------------------------------------
          `STATE_RESET 	:
            begin
               oLCD_Enabled <= 1'b0;
               rEnableDone  <= 1'b0;
               rTimeCountReset <= 1'b1;
                 rNextState <= `STATE_ENAB;
            end
          //------------------------------------------
          `STATE_ENAB:
            begin
               oLCD_Enabled<= 1'b0;
               rEnableDone <= 1'b0;
               rTimeCountReset <= 1'b0;
               if (rTimeCount > 32'd2 )		//se mantiene enalble en 0 por 40ns
                 begin
                    rNextState <= `RESET_COUNT_0;
                 end
               else
                 begin
                    rNextState <= `STATE_ENAB;
                 end
            end
          //-----------------------------------------
          `RESET_COUNT_0  	:
            begin
               oLCD_Enabled<= 1'b0;
               rEnableDone <= 1'b0;
               rTimeCountReset <= 1'b1;
               rNextState <= `SET_UP_ENAB;
            end
          //------------------------------------------
          `SET_UP_ENAB:
            begin
               oLCD_Enabled<= 1'b1;
               rEnableDone <= 1'b0;
               rTimeCountReset <= 1'b0;
               if (rTimeCount > 32'd12 )		//se mantiene enable por 240ns
                 begin
                    rNextState <= `RESET_COUNT_1;
                 end
               else
                 begin
                    rNextState <= `SET_UP_ENAB;
                 end
            end
          //--------------------------------------------
          `RESET_COUNT_1  	:
            begin
               oLCD_Enabled<= 1'b1;
               rEnableDone <= 1'b0;
               rTimeCountReset <= 1'b1;
               rNextState <= `SET_DOWN_ENAB;
            end
          //------------------------------------------
          `SET_DOWN_ENAB:
            begin
               oLCD_Enabled<= 1'b0;
               rEnableDone<= 1'b0;
               rTimeCountReset <= 1'b0;
               if (rTimeCount > 1'b1 )		// se mantiene enable por 20ns
                 begin
                    rNextState <= `RESET_COUNT_2;
                 end
               else
                 begin
                    rNextState <= `SET_DOWN_ENAB;
                 end
            end
          //----------------------------------------------
          `RESET_COUNT_2  	:
            begin
               oLCD_Enabled<= 1'b0;
               rEnableDone <= 1'b0;
               rTimeCountReset <= 1'b1;
               rNextState <= `WRITE_DONE;
            end
          //------------------------------------------
          `WRITE_DONE:
            begin
               oLCD_Enabled<= 1'b0;
 	       rEnableDone<= 1'b1;			//se setea EnableDone para terminar
               rNextState <= `STATE_RESET;
 	    end

   //----------------------------------------------
   default:
     rNextState <= `SET_UP_ENAB;


endcase // case (rCurrentState)
end
endmodule
