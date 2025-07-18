`timescale 1ns / 1ps

`include "Defintions.v"


`define STATE_RESET		0
`define C_KEY			1
`define CS_KEY 			2
`define D_KEY         		3
`define DS_KEY           	4
`define E_KEY       		5
`define LINE			6
`define F_KEY          		7
`define FS_KEY  		8
`define G_KEY			9
`define GS_KEY			10
`define A_KEY			11
`define AS_KEY			12
`define B_KEY			13

//---------------------------------------------------------

`define aC_KEY		 0
`define aCS_KEY 	 1
`define aD_KEY         	 2
`define aDS_KEY          3
`define aE_KEY       	 4
`define aF_KEY           5
`define aFS_KEY  	 6
`define aG_KEY		 7
`define aGS_KEY		 8
`define aA_KEY		 9
`define aAS_KEY		 10
`define aB_KEY		 11

module Module_VGA_Control
  (

   input wire  Clock,
   input wire  Reset,
   output wire oVGA_B,
   output wire oVGA_G,
   output wire oVGA_R,
   output wire oHorizontal_Sync,
   output wire oVertical_Sync,
   input wire  clk_kb,
   input wire  data_kb

   );

   reg [2:0]   rColor [0:11]  ;
   reg [7:0]   rCurrentState,rNextState, rCurrentColorState, rNextColorState;
   reg [31:0]  rTimeCount,  i, j;
   wire [7:0]  ikeyboard;
   wire [31:0] wCurrentRow, wCurrentCol;
   reg         wRam_R, wRam_G, wRam_B;
   reg         rTimeCountReset, rResetCol, rResetRow;
   wire [2:0]  wColor;

   initial begin
      rColor[0] = `COLOR_WHITE;
      rColor[1] = `COLOR_BLACK;
      rColor[2] = `COLOR_WHITE;
      rColor[3] = `COLOR_BLACK;
      rColor[4] = `COLOR_WHITE;
      rColor[5] = `COLOR_WHITE;
      rColor[6] = `COLOR_BLACK;
      rColor[7] = `COLOR_WHITE;
      rColor[8] = `COLOR_BLACK;
      rColor[9] = `COLOR_WHITE;
      rColor[10] = `COLOR_BLACK;
      rColor[11] = `COLOR_WHITE;

      //rColor <= {0,1,1};
      //      {rCurrentRow, rCurrentCol} <= {0,0};
      //{oVertical_Sync, oHorizontal_Sync} <= {0,0};
   end

   crvga crvga1(
                .clock(Clock),
                .reset(Reset),
                .iCrvgaR(wRam_R),.iCrvgaG(wRam_G),.iCrvgaB(wRam_B),
                .oCrvgaR(oVGA_R),.oCrvgaG(oVGA_G),.oCrvgaB(oVGA_B),
                .hoz_sync(oHorizontal_Sync),
                .ver_sync(oVertical_Sync),
                .oCurrentCol(wCurrentCol),
                .oCurrentRow(wCurrentRow)
                );
   keyboard keyboard1(
                      .clk_kb(clk_kb),
                      .data_kb(data_kb),
                      .out_reg(ikeyboard)
                      );

   //assign {oVGA_R, oVGA_B, oVGA_G} = ( rCurrentCol < 100 ||  rCurrentCol > 540 || rCurrentRow < 100 || rCurrentRow > 380 ) ? {0,0,0} : rColor;

   /*assign wColor = (ikeyboard == `RE) ? `COLOR_YELLOW : `COLOR_WHITE;

    */

   //----------------------------------------------
   //Next State and delay logic
   always @ ( posedge Clock )
     begin
        if (Reset)
          begin
             rCurrentState <= `STATE_RESET;
             rCurrentColorState <= `aC_KEY;
             rTimeCount <= 32'b0;
          end
        else
          begin
             if (rTimeCountReset)
               rTimeCount <= 32'b0;
             else
               begin
                  rTimeCount <= rTimeCount + 32'b1;
                  rCurrentState <= rNextState;
                  rCurrentColorState <= rNextColorState;
               end
          end
     end

   //----------------------------------------------
   always @ (
             rColor[0],
             rColor[1],
             rColor[2],
             rColor[3],
             rColor[4],
             rColor[5],
             rColor[6],
             rColor[7],
             rColor[8],
             rColor[9],
             rColor[10],
             rColor[11]
             )

     begin
        case(rCurrentColorState)
          `aC_KEY:
            begin
               rColor[0] <= `COLOR_GREEN;
               rColor[1] <= `COLOR_BLACK;
               rColor[2] <= `COLOR_WHITE;
               rColor[3] <= `COLOR_BLACK;
               rColor[4] <= `COLOR_WHITE;
               rColor[5] <= `COLOR_WHITE;
               rColor[6] <= `COLOR_BLACK;
               rColor[7] <= `COLOR_WHITE;
               rColor[8] <= `COLOR_BLACK;
               rColor[9] <= `COLOR_WHITE;
               rColor[10] <= `COLOR_BLACK;
               rColor[11] <= `COLOR_WHITE;

               if (ikeyboard == `DO)
                 rNextColorState <= `aCS_KEY;
               else
                 rNextColorState <= `aC_KEY;
            end
          `aCS_KEY:
            begin
               rColor[0] <= `COLOR_WHITE;
               rColor[1] <= `COLOR_GREEN;
               rColor[2] <= `COLOR_WHITE;
               rColor[3] <= `COLOR_BLACK;
               rColor[4] <= `COLOR_WHITE;
               rColor[5] <= `COLOR_WHITE;
               rColor[6] <= `COLOR_BLACK;
               rColor[7] <= `COLOR_WHITE;
               rColor[8] <= `COLOR_BLACK;
               rColor[9] <= `COLOR_WHITE;
               rColor[10] <= `COLOR_BLACK;
               rColor[11] <= `COLOR_WHITE;

               if (ikeyboard == `DOs)
                 rNextColorState <= `aD_KEY;
               else
                 rNextColorState <= `aCS_KEY;
            end
          `aD_KEY:
            begin
               rColor[0] <= `COLOR_WHITE;
               rColor[1] <= `COLOR_BLACK;
               rColor[2] <= `COLOR_GREEN;
               rColor[3] <= `COLOR_BLACK;
               rColor[4] <= `COLOR_WHITE;
               rColor[5] <= `COLOR_WHITE;
               rColor[6] <= `COLOR_BLACK;
               rColor[7] <= `COLOR_WHITE;
               rColor[8] <= `COLOR_BLACK;
               rColor[9] <= `COLOR_WHITE;
               rColor[10] <= `COLOR_BLACK;
               rColor[11] <= `COLOR_WHITE;


               if (ikeyboard == `RE)
                 rNextColorState <= `aDS_KEY;
               else
                 rNextColorState <= `aD_KEY;
            end
          `aDS_KEY:
            begin
               rColor[0] <= `COLOR_WHITE;
               rColor[1] <= `COLOR_BLACK;
               rColor[2] <= `COLOR_WHITE;
               rColor[3] <= `COLOR_GREEN;
               rColor[4] <= `COLOR_WHITE;
               rColor[5] <= `COLOR_WHITE;
               rColor[6] <= `COLOR_BLACK;
               rColor[7] <= `COLOR_WHITE;
               rColor[8] <= `COLOR_BLACK;
               rColor[9] <= `COLOR_WHITE;
               rColor[10] <= `COLOR_BLACK;
               rColor[11] <= `COLOR_WHITE;


               if (ikeyboard == `REs)
                 rNextColorState <= `aE_KEY;
               else
                 rNextColorState <= `aDS_KEY;
            end
          `aE_KEY:
            begin
               rColor[0] <= `COLOR_WHITE;
               rColor[1] <= `COLOR_BLACK;
               rColor[2] <= `COLOR_WHITE;
               rColor[3] <= `COLOR_BLACK;
               rColor[4] <= `COLOR_GREEN;
               rColor[5] <= `COLOR_WHITE;
               rColor[6] <= `COLOR_BLACK;
               rColor[7] <= `COLOR_WHITE;
               rColor[8] <= `COLOR_BLACK;
               rColor[9] <= `COLOR_WHITE;
               rColor[10] <= `COLOR_BLACK;
               rColor[11] <= `COLOR_WHITE;


               if (ikeyboard == `MI)
                 rNextColorState <= `aF_KEY;
               else
                 rNextColorState <= `aE_KEY;
            end
          `aF_KEY:
            begin
               rColor[0] <= `COLOR_WHITE;
               rColor[1] <= `COLOR_BLACK;
               rColor[2] <= `COLOR_WHITE;
               rColor[3] <= `COLOR_BLACK;
               rColor[4] <= `COLOR_WHITE;
               rColor[5] <= `COLOR_GREEN;
               rColor[6] <= `COLOR_BLACK;
               rColor[7] <= `COLOR_WHITE;
               rColor[8] <= `COLOR_BLACK;
               rColor[9] <= `COLOR_WHITE;
               rColor[10] <= `COLOR_BLACK;
               rColor[11] <= `COLOR_WHITE;


               if (ikeyboard == `FA)
                 rNextColorState <= `aFS_KEY;
               else
                 rNextColorState <= `aF_KEY;
            end
          `aFS_KEY:
            begin
               rColor[0] <= `COLOR_WHITE;
               rColor[1] <= `COLOR_BLACK;
               rColor[2] <= `COLOR_WHITE;
               rColor[3] <= `COLOR_BLACK;
               rColor[4] <= `COLOR_WHITE;
               rColor[5] <= `COLOR_WHITE;
               rColor[6] <= `COLOR_GREEN;
               rColor[7] <= `COLOR_WHITE;
               rColor[8] <= `COLOR_BLACK;
               rColor[9] <= `COLOR_WHITE;
               rColor[10] <= `COLOR_BLACK;
               rColor[11] <= `COLOR_WHITE;

               if (ikeyboard == `FAs)
                 rNextColorState <= `aG_KEY;
               else
                 rNextColorState <= `aFS_KEY;
            end
          `aG_KEY:
            begin
               rColor[0] <= `COLOR_WHITE;
               rColor[1] <= `COLOR_BLACK;
               rColor[2] <= `COLOR_WHITE;
               rColor[3] <= `COLOR_BLACK;
               rColor[4] <= `COLOR_WHITE;
               rColor[5] <= `COLOR_WHITE;
               rColor[6] <= `COLOR_BLACK;
               rColor[7] <= `COLOR_GREEN;
               rColor[8] <= `COLOR_BLACK;
               rColor[9] <= `COLOR_WHITE;
               rColor[10] <= `COLOR_BLACK;
               rColor[11] <= `COLOR_WHITE;

               if (ikeyboard == `SOL)
                 rNextColorState <= `aGS_KEY;
               else
                 rNextColorState <= `aG_KEY;
            end
          `aGS_KEY:
            begin
               rColor[0] <= `COLOR_WHITE;
               rColor[1] <= `COLOR_BLACK;
               rColor[2] <= `COLOR_WHITE;
               rColor[3] <= `COLOR_BLACK;
               rColor[4] <= `COLOR_WHITE;
               rColor[5] <= `COLOR_WHITE;
               rColor[6] <= `COLOR_BLACK;
               rColor[7] <= `COLOR_WHITE;
               rColor[8] <= `COLOR_GREEN;
               rColor[9] <= `COLOR_WHITE;
               rColor[10] <= `COLOR_BLACK;
               rColor[11] <= `COLOR_WHITE;

               if (ikeyboard == `SOLs)
                 rNextColorState <= `aA_KEY;
               else
                 rNextColorState <= `aGS_KEY;
            end
          `aA_KEY:
            begin
               rColor[0] <= `COLOR_WHITE;
               rColor[1] <= `COLOR_BLACK;
               rColor[2] <= `COLOR_WHITE;
               rColor[3] <= `COLOR_BLACK;
               rColor[4] <= `COLOR_WHITE;
               rColor[5] <= `COLOR_WHITE;
               rColor[6] <= `COLOR_BLACK;
               rColor[7] <= `COLOR_WHITE;
               rColor[8] <= `COLOR_BLACK;
               rColor[9] <= `COLOR_GREEN;
               rColor[10] <= `COLOR_BLACK;
               rColor[11] <= `COLOR_WHITE;

               if (ikeyboard == `LA)
                 rNextColorState <= `aAS_KEY;
               else
                 rNextColorState <= `aA_KEY;
            end
          `aAS_KEY:
            begin
               rColor[0] <= `COLOR_WHITE;
               rColor[1] <= `COLOR_BLACK;
               rColor[2] <= `COLOR_WHITE;
               rColor[3] <= `COLOR_BLACK;
               rColor[4] <= `COLOR_WHITE;
               rColor[5] <= `COLOR_WHITE;
               rColor[6] <= `COLOR_BLACK;
               rColor[7] <= `COLOR_WHITE;
               rColor[8] <= `COLOR_BLACK;
               rColor[9] <= `COLOR_WHITE;
               rColor[10] <= `COLOR_GREEN;
               rColor[11] <= `COLOR_WHITE;
               if (ikeyboard == `LAs)
                 rNextColorState <= `aB_KEY;
               else
                 rNextColorState <= `aAS_KEY;
            end
          `aB_KEY:
            begin
               rColor[0] <= `COLOR_WHITE;
               rColor[1] <= `COLOR_BLACK;
               rColor[2] <= `COLOR_WHITE;
               rColor[3] <= `COLOR_BLACK;
               rColor[4] <= `COLOR_WHITE;
               rColor[5] <= `COLOR_WHITE;
               rColor[6] <= `COLOR_BLACK;
               rColor[7] <= `COLOR_WHITE;
               rColor[8] <= `COLOR_BLACK;
               rColor[9] <= `COLOR_WHITE;
               rColor[10] <= `COLOR_BLACK;
               rColor[11] <= `COLOR_GREEN;
               if (ikeyboard == `SI)
                 rNextColorState <= `aC_KEY;
               else
                 rNextColorState <= `aB_KEY;
            end
          default:
            begin
               rColor[0] <= 0;
               rNextColorState <= `aC_KEY;
            end
        endcase
     end

   //----------------------------------------------
   //Current state and output logic
   always @ ( //*

              rColor[0],
              rColor[1],
              rColor[2],
              rColor[3],
              rColor[4],
              rColor[5],
              rColor[6],
              rColor[7],
              rColor[8],
              rColor[9],
              rColor[10],
              rColor[11]

              )
     begin
        case (rCurrentState)
          //------------------------------------------

          `STATE_RESET:
            begin
               //rColor <= {0,1,1};
               {wRam_R, wRam_G, wRam_B} <= `COLOR_BLUE;

               if (wCurrentRow > 99 && wCurrentRow < 380)
                 rNextState <= `C_KEY;
               else
                 rNextState <= `STATE_RESET;
            end
          //------------------------------------------
          //DO
          `C_KEY:
            begin
               if (ikeyboard == `DO)
                 {wRam_R, wRam_G, wRam_B} <= `COLOR_YELLOW;
               else
                 //{wRam_R, wRam_G, wRam_B} <= `COLOR_WHITE;
                 {wRam_R, wRam_G, wRam_B} <= rColor[0];
               if (wCurrentCol > 52)
                 if(wCurrentRow < 240)       // es necesario revisar la fila, para ir a LINE
                   rNextState <= `CS_KEY;
                 else if(wCurrentCol > 74)        // si la fila es mayor a 240, se debe imprimir un poco mas blanco y luego ir a LINE
                   rNextState <= `LINE;
                 else
                   rNextState <= `C_KEY;
               else
                 rNextState <= `C_KEY;
            end
          //------------------------------------------
          //DO#
          `CS_KEY:
            begin
               if (ikeyboard == `DOs)
                 {wRam_R, wRam_G, wRam_B} <= `COLOR_YELLOW;
               else
                 //{wRam_R, wRam_G, wRam_B} <= `COLOR_BLACK;
                 {wRam_R, wRam_G, wRam_B} <= rColor[1];
               if (wCurrentCol > 105)
                 rNextState <= `D_KEY;
               else
                 rNextState <= `CS_KEY;
            end
          //------------------------------------------
          //RE
          `D_KEY:
            begin
               if (ikeyboard == `RE)
                 {wRam_R, wRam_G, wRam_B} <= `COLOR_YELLOW;
               else
                 //{wRam_R, wRam_G, wRam_B} <= `COLOR_WHITE;
                 {wRam_R, wRam_G, wRam_B} <= rColor[2];
               if (wCurrentCol > 158)
                 if(wCurrentRow < 240)
                   rNextState <= `DS_KEY;
                 else if(wCurrentCol > 180)
                   rNextState <= `LINE;
                 else
                   rNextState <= `D_KEY;
               else
                 rNextState <= `D_KEY;
            end
          //------------------------------------------
          //RE#
          `DS_KEY:
            begin
               if (ikeyboard == `REs)
                 {wRam_R, wRam_G, wRam_B} <= `COLOR_YELLOW;
               else
                 //{wRam_R, wRam_G, wRam_B} <= `COLOR_BLACK;
                 {wRam_R, wRam_G, wRam_B} <= rColor[3];
               if (wCurrentCol >211)
                 rNextState <= `E_KEY;
               else
                 rNextState <= `DS_KEY;
            end
          //------------------------------------------

          //MI
          `E_KEY:
            begin
               if (ikeyboard == `MI)
                 {wRam_R, wRam_G, wRam_B} <= `COLOR_YELLOW;
               else
                 //{wRam_R, wRam_G, wRam_B} <= `COLOR_WHITE;
                 {wRam_R, wRam_G, wRam_B} <= rColor[4];
               if (wCurrentCol >264)
                 rNextState <= `LINE;
               else
                 rNextState <= `E_KEY;
            end
          //------------------------------------------
          //FA
          `F_KEY:
            begin
               if (ikeyboard == `FA)
                 {wRam_R, wRam_G, wRam_B} <= `COLOR_YELLOW;
               else
                 //{wRam_R, wRam_G, wRam_B} <= `COLOR_WHITE;
                 {wRam_R, wRam_G, wRam_B} <= rColor[5];
               if (wCurrentCol >321)
                 if(wCurrentRow < 240)
                   rNextState <= `FS_KEY;
                 else if(wCurrentCol > 343)
                   rNextState <= `LINE;
                 else
                   rNextState <= `F_KEY;
               else
                 rNextState <= `F_KEY;
            end
          //------------------------------------------
          //FA#
          `FS_KEY:
            begin
               if (ikeyboard == `FAs)
                 {wRam_R, wRam_G, wRam_B} <= `COLOR_YELLOW;
               else
                 //{wRam_R, wRam_G, wRam_B} <= `COLOR_BLACK;
                 {wRam_R, wRam_G, wRam_B} <= rColor[6];
               if (wCurrentCol >374)
                 rNextState <= `G_KEY;
               else
                 rNextState <= `FS_KEY;
            end
          //------------------------------------------
          //SOL
          `G_KEY:
            begin
               if (ikeyboard == `SOL)
                 {wRam_R, wRam_G, wRam_B} <= `COLOR_YELLOW;
               else
                 //{wRam_R, wRam_G, wRam_B} <= `COLOR_WHITE;
                 {wRam_R, wRam_G, wRam_B} <= rColor[7];
               if (wCurrentCol >427)
                 if(wCurrentRow < 240)
                   rNextState <= `GS_KEY;
                 else if(wCurrentCol > 449)
                   rNextState <= `LINE;
                 else
                   rNextState <= `G_KEY;
               else
                 rNextState <= `G_KEY;
            end
          //------------------------------------------
          //SOL#
          `GS_KEY:
            begin
               if (ikeyboard == `SOLs)
                 {wRam_R, wRam_G, wRam_B} <= `COLOR_YELLOW;
               else
                 //{wRam_R, wRam_G, wRam_B} <= `COLOR_BLACK;
                 {wRam_R, wRam_G, wRam_B} <= rColor[8];
               if (wCurrentCol >480)
                 rNextState <= `A_KEY;
               else
                 rNextState <= `GS_KEY;
            end
          //------------------------------------------
          //LA
          `A_KEY:
            begin
               if (ikeyboard == `LA)
                 {wRam_R, wRam_G, wRam_B} <= `COLOR_YELLOW;
               else
                 //{wRam_R, wRam_G, wRam_B} <= `COLOR_WHITE;
                 {wRam_R, wRam_G, wRam_B} <= rColor[9];
               if (wCurrentCol >533)
                 if(wCurrentRow < 240)
                   rNextState <= `AS_KEY;
                 else if(wCurrentCol > 555)
                   rNextState <= `LINE;
                 else
                   rNextState <= `A_KEY;
               else
                 rNextState <= `A_KEY;
            end
          //------------------------------------------
          //LAS
          `AS_KEY:
            begin
               if (ikeyboard == `LAs)
                 {wRam_R, wRam_G, wRam_B} <= `COLOR_YELLOW;
               else
                 //{wRam_R, wRam_G, wRam_B} <= `COLOR_BLACK;
                 {wRam_R, wRam_G, wRam_B} <= rColor[10];
               if (wCurrentCol >586)
                 rNextState <= `B_KEY;
               else
                 rNextState <= `AS_KEY;
            end
          //------------------------------------------
          `LINE: // depende de las columnas debe regresar a un estado diferente
            begin
               {wRam_R, wRam_G, wRam_B} <= `COLOR_BLACK;
               if (wCurrentCol > 78 && wCurrentCol < 179)
                 rNextState <= `D_KEY;
               else  if (wCurrentCol > 184 && wCurrentCol < 263)
                 rNextState <= `E_KEY;
               else  if (wCurrentCol > 268 && wCurrentCol < 342)
                 rNextState <= `F_KEY;
               else  if (wCurrentCol > 347 && wCurrentCol < 448)
                 rNextState <= `G_KEY;
               else  if (wCurrentCol > 453 && wCurrentCol < 554)
                 rNextState <= `A_KEY;
               else  if (wCurrentCol > 559)
                 rNextState <= `B_KEY;
               else
                 rNextState <= `LINE;
            end
          //------------------------------------------
          //SI
          `B_KEY:
            begin
               if (ikeyboard == `SI)
                 {wRam_R, wRam_G, wRam_B} <= `COLOR_YELLOW;
               else
                 //{wRam_R, wRam_G, wRam_B} <= `COLOR_WHITE;
                 {wRam_R, wRam_G, wRam_B} <= rColor[11];
               if (wCurrentRow >379)
                 rNextState <= `STATE_RESET;
               else if(wCurrentCol==0)
                 rNextState <= `C_KEY;
               else
                 rNextState <= `B_KEY;
            end
          //------------------------------------------
          default:
            begin
               {wRam_R, wRam_G, wRam_B} <= {0,0,1};
               rNextState <= `STATE_RESET;
            end
          //------------------------------------------
        endcase
     end
endmodule
