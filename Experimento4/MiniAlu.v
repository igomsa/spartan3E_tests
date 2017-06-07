`timescale 1ns / 1ps
`include "Defintions.v"


module MiniAlu
  (

   input wire  Clock,
   input wire  Reset,
   output wire oVGA_B,
   output wire oVGA_G,
   output wire oVGA_R,
   output wire oHorizontal_Sync,
   output wire oVertical_Sync

   );

   wire [15:0] wIP,wIP_temp;
   reg         rWriteEnable,rBranchTaken;
   wire [27:0] wInstruction;
   wire [3:0]  wOperation;
   reg signed [15:0] rResult;
   wire signed [7:0] wSourceAddr0,wSourceAddr1;
   wire [7:0]        wDestination;
   wire [15:0]       wSourceData0,wSourceData1,wIPInitialValue,wImmediateValue;




   ROM InstructionRom
     (
      .iAddress    (     wIP      ),
      .oInstruction( wInstruction )
      );

   // Instanciar la memoria
   RAM_SINGLE_READ_PORT # (3,24,640*480) VideoMemory
     (
      .Clock	      ( Clock 				 ),
      .iWriteEnable ( rVGAWritEnable 			 ),
      .iReadAddress ( 24'b0 				 ),
      .iWriteAddress( {wSourceData1[7:0],wSourceData0} ),
      .iDataIn      ( wInstruction[23:21] 		 ),
      .oDataOut     ( {oVGA_R,oVGA_G,oVGA_B} 		 )
      );

   assign wIPInitialValue = (Reset) ? 8'b0 : wDestination;
   UPCOUNTER_POSEDGE IP
     (
      .Clock  (  Clock                ),
      .Reset  (  Reset | rBranchTaken ),
      .Initial( wIPInitialValue + 1   ),
      .Enable (  1'b1                 ),
      .Q      (  wIP_temp             )
      );
   assign wIP = (rBranchTaken) ? wIPInitialValue : wIP_temp;

   FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD1
     (
      .Clock(Clock),
      .Reset(Reset),
      .Enable(1'b1),
      .D(wInstruction[27:24]),
      .Q(wOperation)
      );

   FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD2
     (
      .Clock(Clock),
      .Reset(Reset),
      .Enable(1'b1),
      .D(wInstruction[7:0]),
      .Q(wSourceAddr0)
      );

   FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD3
     (
      .Clock(Clock),
      .Reset(Reset),
      .Enable(1'b1),
      .D(wInstruction[15:8]),
      .Q(wSourceAddr1)
      );

   FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD4
     (
      .Clock(Clock),
      .Reset(Reset),
      .Enable(1'b1),
      .D(wInstruction[23:16]),
      .Q(wDestination)
      );

   /***************** No se necesita pero sirve de referencia ********
    reg rFFLedEN;
    FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FF_LEDS
    (
    .Clock(Clock),
    .Reset(Reset),
    .Enable( rFFLedEN ),
    .D( wSourceData1 ),
    .Q( oLed    )
    );
    */

   assign wImmediateValue = {wSourceAddr1,wSourceAddr0};

   initial begin
      oHorizontal_Sync <= 0;
      oVertical_Sync <= 0;
   end



   always @ ( * )
     begin
        case (wOperation)
          //-------------------------------------
          `NOP:
            begin
               rVGAWritEnable     <= 1'b0;
               rBranchTaken <= 1'b0;
               rWriteEnable <= 1'b0;
               rResult      <= 0;
            end
          //-------------------------------------
          `ADD:
            begin
               rVGAWritEnable     <= 1'b0;
               rBranchTaken <= 1'b0;
               rWriteEnable <= 1'b1;
               rResult   <= wSourceData1 + wSourceData0;
            end
          //-------------------------------------
          `SUB:
            begin
               rVGAWritEnable     <= 1'b0;
               rBranchTaken <= 1'b0;
               rWriteEnable <= 1'b1;
               rResult   <= wSourceData1 - wSourceData0;
            end
          //-------------------------------------

          `MUL:
            begin
               rVGAWritEnable     <= 1'b0;
               rBranchTaken <= 1'b0;
               rWriteEnable <= 1'b1;
               rResult   <= wSourceData1 * wSourceData0;
            end

          //-------------------------------------

          `VGA:
            begin
               rVGAWritEnable     <= 1'b1;
               rBranchTaken <= 1'b0;
               rWriteEnable <= 1'b';
               rResult   <= 1'b0;
               oHorizontal_Sync <= SourceData0;
               oVertical_Sync <= SourceData1;
            end

          //-------------------------------------

          `STO:
            begin
               rVGAWritEnable     <= 1'b0;
               rWriteEnable <= 1'b1;
               rBranchTaken <= 1'b0;
               rResult      <= wImmediateValue;
            end
          //-------------------------------------
          `BLE:
            begin
               rVGAWritEnable     <= 1'b0;
               rWriteEnable <= 1'b0;
               rResult      <= 0;
               if (wSourceData1 <= wSourceData0 )
                 rBranchTaken <= 1'b1;
               else
                 rBranchTaken <= 1'b0;

	    end
	  //-------------------------------------
	  `JMP:
	    begin
	       rVGAWritEnable     <= 1'b0;
	       rWriteEnable <= 1'b0;
	       rResult      <= 0;
	       rBranchTaken <= 1'b1;
	    end
	  //-------------------------------------
          /*
	   `LED:
	   begin
	   rVGAWritEnable     <= 1'b1;
	   rWriteEnable <= 1'b0;
	   rResult      <= 0;
	   rBranchTaken <= 1'b0;
	end
           */
	  //-------------------------------------
	  default:
	    begin
	       rVGAWritEnable     <= 1'b1;
	       rWriteEnable <= 1'b0;
	       rResult      <= 0;
	       rBranchTaken <= 1'b0;
	    end
	  //-------------------------------------
	endcase
     end


endmodule
