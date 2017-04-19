`timescale 1ns / 1ps
`include "Defintions.v"


module MiniAlu
(
 input wire Clock,
 input wire Reset,
 output wire [7:0] oLed


);

wire [15:0]  wIP,wIP_temp;
reg         rWriteEnable,rBranchTaken;
wire [27:0] wInstruction;
wire [3:0]  wOperation;
reg [15:0]   rResult;
wire [7:0]  wSourceAddr0,wSourceAddr1,wDestination;
wire [15:0] wSourceData0,wSourceData1,wIPInitialValue,wImmediateValue;




ROM InstructionRom
(
	.iAddress(     wIP          ),
	.oInstruction( wInstruction )
);

RAM_DUAL_READ_PORT DataRam
(
	.Clock(         Clock        ),
	.iWriteEnable(  rWriteEnable ),
	.iReadAddress0( wInstruction[7:0] ),
	.iReadAddress1( wInstruction[15:8] ),
	.iWriteAddress( wDestination ),
	.iDataIn(       rResult      ),
	.oDataOut0(     wSourceData0 ),
	.oDataOut1(     wSourceData1 )
);

assign wIPInitialValue = (Reset) ? 8'b0 : wDestination;
UPCOUNTER_POSEDGE IP
(
.Clock(   Clock                ),
.Reset(   Reset | rBranchTaken ),
.Initial( wIPInitialValue + 1  ),
.Enable(  1'b1                 ),
.Q(       wIP_temp             )
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


reg rFFLedEN;
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FF_LEDS
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable( rFFLedEN ),
	.D( wSourceData1 ),
	.Q( oLed    )
);

assign wImmediateValue = {wSourceAddr1,wSourceAddr0};

//----------------------------------------------------------------------
//Se introduce código para realizar instancias de manera automática
//a manera de arreglo de 15x14

wire[15:0] wCarry[14:0];
wire [15:0] wResult [15:0];
   genvar CurrentRow, CurrentCol;
   generate
      for (CurrentRow = 0; CurrentRow < 14; CurrentRow = CurrentRow +1)
        begin: MUL_ROW
           for ( CurrentCol = 0; CurrentCol < 15; CurrentCol = CurrentCol + 1)
             begin: MUL_COL
                if (CurrentCol == 0)
                  begin
                     assign wCarry[ CurrentRow ][ 0 ] = 0;
                  end
                else
                  begin
                     if (CurrentRow == 0)
                       begin
                          EMUL #(4) MyAdder
                            (
                             .wA( wSourceData0[CurrentRow] & wSourceData1[CurrentCol] ),
                             .wB( wSourceData0[CurrentRow] & wSourceData1[CurrentCol] ),
                             .iCarry( wCarry[ CurrentRow ][ CurrentCol ] ),
                             .oCarry( wCarry[ CurrentRow ][ CurrentCol + 1]),
                             .oR(wResult[CurrentCol][CurrentRow])
                             );
                       end
                     else if (CurrentCol == 13)
                       begin
                          EMUL # (4) MyAdder
                            (
                             .wA( wSourceData0[CurrentRow] & wSourceData1[CurrentCol] ),
                             .wB( wSourceData0[CurrentRow] & wSourceData1[CurrentCol] ),
                             .iCarry( wCarry[ CurrentRow ][ CurrentCol ] ),
                             .oCarry( wCarry[ CurrentRow +1 ][ CurrentCol]),
                             .oR(wResult[CurrentCol][CurrentRow])
                             );
                          end
                     else
                       begin
                          if (CurrentCol != 13)
                            begin
                               EMUL # (4) MyAdder (
                                  .wA( wSourceData0[CurrentRow] & wSourceData1[CurrentCol] ),
                                  .wB( wSourceData0[CurrentRow] & wSourceData1[CurrentCol] ),
                   	          .iCarry( wCarry[ CurrentRow ][ CurrentCol ] ),
                   	          .oCarry( wCarry[ CurrentRow ][ CurrentCol + 1]),
                                  .oR(wResult[CurrentCol][CurrentRow])
                                  );
                            end
                       end
                  end
             end
        end
   endgenerate

//----------------------------------------------------------------------

always @ ( * )
begin
        case (wOperation)
        //-------------------------------------
	`NOP:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
	end
	//-------------------------------------
	`ADD:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		rResult   <= wSourceData1 + wSourceData0;
	end
        //-------------------------------------
	`SUB:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		rResult   <= wSourceData1 - wSourceData0;
	end
        //-------------------------------------

	`MUL:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;

           rResult <= {8'b0, wResult[0][6], wResult[5][0], wResult[4][0], wResult[3][0], wResult[2][0], wResult[1][0], wResult[0][0], wSourceData1[0] & wSourceData0[0]};

/*
           #1 rResult <= {8'b0, wCarry[11], wResult[2][3], wResult[2][2], wResult[2][1], wResult[2][0], wResult[1][0], wResult[0][0], wSourceData1[0] & wSourceData1[0]};

           #1 rResult <= {8'b0, wCarry[11], wResult[2][3], wResult[2][2], wResult[2][1], wResult[2][0], wResult[1][0], wResult[0][0], wSourceData1[0] & wSourceData1[0]};

           #1 rResult <= {8'b0, wCarry[11], wResult[2][3], wResult[2][2], wResult[2][1], wResult[2][0], wResult[1][0], wResult[0][0], wSourceData1[0] & wSourceData1[0]};
*/
        end
	//-------------------------------------
	`STO:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b1;
		rBranchTaken <= 1'b0;
		rResult      <= wImmediateValue;
	end
	//-------------------------------------
	`BLE:
	begin
		rFFLedEN     <= 1'b0;
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
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b1;
	end
	//-------------------------------------
	`LED:
	begin
		rFFLedEN     <= 1'b1;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b0;
	end
	//-------------------------------------
	default:
	begin
		rFFLedEN     <= 1'b1;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b0;
	end
	//-------------------------------------
	endcase
end


endmodule
