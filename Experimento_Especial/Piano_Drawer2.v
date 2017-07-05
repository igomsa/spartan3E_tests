`timescale 1ns / 1ps

`include "Defintions.v"

`define STATE_RESET			0
`define C_KEY					1
`define CS_KEY 				2
`define D_KEY         		3
`define DS_KEY           	4
`define E_KEY       			5
`define LINE					6
`define F_KEY          		7
`define FS_KEY  				8
`define G_KEY					9
`define GS_KEY					10
`define A_KEY					11
`define AS_KEY					12
`define B_KEY					13

module Module_VGA_Control
  (

   input wire  Clock,
   input wire  Reset,
   output wire oVGA_B,
   output wire oVGA_G,
   output wire oVGA_R,
   output wire  oHorizontal_Sync,
   output wire  oVertical_Sync,
	input wire clk_kb,
	input wire data_kb

   );

   reg [3:0]   rColor;
   reg [7:0]   rCurrentState,rNextState;
   reg [31:0]  rTimeCount,  i, j;
	wire [7:0] ikeyboard;
   wire [31:0] wCurrentRow, wCurrentCol;
	reg wRam_R, wRam_G, wRam_B;
   reg         rTimeCountReset, rResetCol, rResetRow;
	wire [2:0]  wColor;

   initial begin
      rColor <= {0,1,1};
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
	assign wColor = (ikeyboard == `RE) ? `COLOR_YELLOW : `COLOR_WHITE;  

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

        //Current state and output logic
        always @ ( * )
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
                   {wRam_R, wRam_G, wRam_B} <= `COLOR_WHITE;
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
                    {wRam_R, wRam_G, wRam_B} <= `COLOR_BLACK;
                    if (wCurrentCol > 105)
                      rNextState <= `D_KEY;
                    else
                      rNextState <= `CS_KEY;
                 end
//------------------------------------------
					//RE
               `D_KEY:
                 begin
                    {wRam_R, wRam_G, wRam_B} <= wColor;
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
                    {wRam_R, wRam_G, wRam_B} <= `COLOR_BLACK;
                    if (wCurrentCol >211)
                      rNextState <= `E_KEY;
                    else
                      rNextState <= `DS_KEY;
                 end
//------------------------------------------

					//MI
               `E_KEY:
                 begin
                    {wRam_R, wRam_G, wRam_B} <= `COLOR_WHITE;
                    if (wCurrentCol >264)
                      rNextState <= `LINE;
                    else
                      rNextState <= `E_KEY;
                 end
//------------------------------------------
					//FA
               `F_KEY:
                 begin
                    {wRam_R, wRam_G, wRam_B} <= `COLOR_WHITE;
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
                    {wRam_R, wRam_G, wRam_B} <= `COLOR_BLACK;
                    if (wCurrentCol >374)
                      rNextState <= `G_KEY;
                    else
                      rNextState <= `FS_KEY;
                 end
               //------------------------------------------
					//SOL
               `G_KEY:
                 begin
                    {wRam_R, wRam_G, wRam_B} <= `COLOR_WHITE;
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
                    {wRam_R, wRam_G, wRam_B} <= `COLOR_BLACK;
                    if (wCurrentCol >480)
                      rNextState <= `A_KEY;
                    else
                      rNextState <= `GS_KEY;
                 end
               //------------------------------------------
					//LA
               `A_KEY:
                 begin
                    {wRam_R, wRam_G, wRam_B} <= `COLOR_WHITE;
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
                    {wRam_R, wRam_G, wRam_B} <= `COLOR_BLACK;
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
               `B_KEY:
                 begin
                    {wRam_R, wRam_G, wRam_B} <= `COLOR_WHITE;
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
