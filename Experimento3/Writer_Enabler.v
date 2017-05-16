`timescale 1ns / 1ps
`define STATE_ENAB 	0
`define SET_UP_ENAB	1
`define SET_DOWN_ENAB	2
`define	WRITE_DONE	3
`define STATE_RESET 4
module Module_Write_Enable
  (
   input wire  Reset,
   input wire  Clock,
   output wire oLCD_Enabled,
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
               oLCD_Enabled = 1'b0;
               rEnableDone  = 1'b0;
               rTimeCountReset <= 1'b1;
                 rNextState <= `STATE_RESET;
            end
          //------------------------------------------
          `STATE_ENAB:
            begin
               oLCD_Enabled = 1'b0;
               rEnableDone  = 1'b0;
               rTimeCountReset <= 1'b1;
               if (rTimeCount > 32'd2 )		//se mantiene enalble en 0 por 40ns
                 begin
                    rNextState = `SET_UP_ENAB;
                    rTimeCount = 32'b0;
                 end
               else
                 begin
                    rNextState= `STATE_ENAB;

                 end
            end
          //-----------------------------------------
          `SET_UP_ENAB:
            begin
               oLCD_Enabled = 1'b1;
               rEnableDone  = 1'b0;
               if (rTimeCount > 32'd12 )		//se mantiene enable por 240ns
                 begin
                    rNextState = `SET_DOWN_ENAB;
                    rTimeCount = 32'b0;
                 end
               else
                 begin
                    rNextState = `SET_UP_ENAB;

                 end
            end
          //--------------------------------------------
          `SET_DOWN_ENAB:
            begin
               oLCD_Enabled = 1'b0;
               rEnableDone = 1'b0;
               if (rTimeCount > 1'b1 )		// se mantiene enable por 20ns
                 begin
                    rNextState = `WRITE_DONE;
                    rTimeCount = 1'b0;
                 end
               else
                 begin
                    rNextState = `SET_DOWN_ENAB;

                 end
            end
          //----------------------------------------------
          `WRITE_DONE:
            begin
               oLCD_Enabled = 1'b0;
 	       rEnableDone = 1'b1;			//se setea EnableDone para terminar
 	    end

   //----------------------------------------------
   default:
     rNextState <= `SET_UP_ENAB;


endcase // case (rCurrentState)
end
endmodule
