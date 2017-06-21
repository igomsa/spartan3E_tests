`timescale 1ns / 1ps

`include "Defintions.v"

`define STATE_RESET       0
`define PULSE_WIDTH_TIME  1
`define BACK_PORCH_TIME   2
`define SET_GREEN         3
`define SET_RED           4
`define SET_MAGENTA       5
`define SET_BLUE          6
`define FRONT_PORCH_TIME  7

module Module_VGA_Control
  (

   input wire  Clock,
   input wire  Reset,
   output wire oVGA_B,
   output wire oVGA_G,
   output wire oVGA_R,
   output reg  oHorizontal_Sync,
   output reg  oVertical_Sync

   );

   reg [3:0]   rColor;
   reg [7:0]   rCurrentState,rNextState;
   reg [31:0]  rTimeCount, rCurrentRow, rCurrentCol, i, j;
   reg         rTimeCountReset;


   initial begin
      rColor <= {0,0,0};
      {rCurrentRow, rCurrentCol} <= {0,0};
      {oVertical_Sync, oHorizontal_Sync} <= {0,0};
   end


   //assign {oVGA_R, oVGA_B, oVGA_G} = ( rCurrentCol < 100 ||  rCurrentCol > 540 || rCurrentRow < 100 || rCurrentRow > 380 ) ? {0,0,0} : rColor;


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
               rTimeCount <= 32'b0;
             else
               rTimeCount <= rTimeCount + 32'b1;
             rCurrentState <= rNextState;
          end
     end
   //----------------------------------------------

   //Col and Row counter
   always @ ( posedge Clock )
     begin
        if (Reset)
          begin
             {rCurrentRow, rCurrentCol} <= {0,0};
          end
        else
          begin
             if (rCurrentRow < 480)
               begin
                  //for (i= 0; i < 480; i = i +1)
                  // begin
                  if (rCurrentCol<640)
                    begin
                       //for (j = 0; j < 640 ; j = i+1)
                       //  begin
                       oHorizontal_Sync <= 1;
                       rCurrentCol <= rCurrentCol + 1;
                    end
                  else
                    begin
                       rCurrentCol <= 0;
                       oHorizontal_Sync <= 0;
                       rCurrentRow <= rCurrentRow + 1;
                    end
                  oVertical_Sync <= 1;
               end
             else
               begin
                  rCurrentRow <= 0;
                  oVertical_Sync <= 0;
               end
          end
     end
   //----------------------------------------------

        //Current state and output logic
        always @ ( * )
          begin
             case (rCurrentState)
               //------------------------------------------

               `STATE_RESET:
                 begin
                    //rColor <= {0,0,0};
                    {oVGA_R, oVGA_B, oVGA_G} <= `COLOR_BLACK;
                    oVertical_Sync <= 0;
                    oHorizontal_Sync <= 0;
                    //if (rCurrentCol >= 100 ||  rCurrentCol <= 540 || rCurrentRow >= 100 || rCurrentRow <= 380)
                      rNextState <= `SET_GREEN;
                 end
               //------------------------------------------

               `PULSE_WIDTH_TIME:
                 begin
                    rColor <= `COLOR_BLACK;
                    oVertical_Sync <= 0;
                    oHorizontal_Sync <= 0;
                    if (rTimeCount < 1600)
                      rNextState <= `PULSE_WIDTH_TIME;
                    else
                      begin
                         rNextState <= `BACK_PORCH_TIME;
                         rTimeCountReset <= 1;
                      end
                 end
               //------------------------------------------

               `BACK_PORCH_TIME:
                 begin
                    rColor <= `COLOR_BLACK;
                    oVertical_Sync <= 0;
                    oHorizontal_Sync <= 0;
                    if (rTimeCount < 23200)
                      rNextState <= `BACK_PORCH_TIME;
                    else
                      begin
                         rNextState <= `SET_GREEN;
                         rTimeCountReset <= 1;
                      end
                 end
               //------------------------------------------

               `SET_GREEN:
                 begin
                    rColor <= `COLOR_GREEN;
                    if (rCurrentRow > 170)
                      rNextState <= `SET_RED;
                    else
                      rNextState <= `SET_GREEN;
                 end
               //------------------------------------------

               `SET_RED:
                 begin
                    rColor <= `COLOR_RED;
                    if (rCurrentRow > 240)
                      rNextState <= `SET_MAGENTA;
                    else
                      rNextState <= `SET_RED;
                 end
               //------------------------------------------

               `SET_MAGENTA:
                 begin
                    rColor <= `COLOR_MAGENTA;
                    if (rCurrentRow > 310)
                      rNextState <= `SET_BLUE;
                    else
                      rNextState <= `SET_MAGENTA;
                 end
               //------------------------------------------

               `SET_BLUE:
                 begin
                    rColor <= `COLOR_BLUE;
                    if (rCurrentRow > 380)
                      rNextState <= `STATE_RESET;
                    else
                      rNextState <= `SET_BLUE;
                 end
               //------------------------------------------

               default:
                 begin
                    rColor <= {0,0,0};
                    rNextState <= `STATE_RESET;
                 end
               //------------------------------------------
             endcase
          end
endmodule
