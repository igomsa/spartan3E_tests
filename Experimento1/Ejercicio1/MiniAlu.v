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
wire [11:0]   wCarry;
wire [3:0] wResult [3:0];




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

                /*wSourceData1[0] & wSourceData0[1] <= wSourceData1[0] & wSourceData0[1];
                wSourceData1[1] & wSourceData0[0] <= wsourcedata1[1] & wsourcedata0[0];
                wSourceData1[2] & wSourceData0[0] <= wSourceData1[2] & wSourceData0[0];
                wSourceData1[1] & wSourceData0[1] <= wSourceData1[1] & wSourceData0[1];
                wSourceData1[3] & wSourceData0[0] <= wSourceData1[3] & wSourceData0[0];
                wSourceData1[2] & wSourceData0[1] <= wSourceData1[2] & wSourceData0[1];
                1'b0 <= 1'b0;
                wSourceData1[3] & wSourceData0[1] <= wSourceData1[3] & wSourceData0[1];
                wSourceData1[0] & wSourceData0[2] <= wSourceData1[0] & wSourceData0[2];
                wSourceData1[1] & wSourceData0[2] <= wSourceData1[1] & wSourceData0[2];
                wSourceData1[2] & wSourceData0[2] <= wSourceData1[2] & wSourceData0[2];
                wSourceData1[3] & wSourceData0[2] <= wSourceData1[3] & wSourceData0[2];
                wSourceData1[0] & wSourceData0[3] <= wSourceData1[0] & wSourceData0[3];
                wSourceData1[1] & wSourceData0[3] <= wSourceData1[1] & wSourceData0[3];
                wSourceData1[2] & wSourceData0[3] <= wSourceData1[2] & wSourceData0[3];
                wSourceData1[3] & wSourceData0[3] <= wSourceData1[3] & wSourceData0[3];*/
                EMUL mul0(.wA(wSourceData1[0] & wSourceData0[1]), .wB(wSourceData1[1] & wSourceData0[0]), .iCarry(1'b0),  .oCarry(wCarry[0]), .oR(wResult[0][0]));
                EMUL mul1(.wA(wSourceData1[2] & wSourceData0[0]), .wB(wSourceData1[1] & wSourceData0[1]), .iCarry(wCarry[0]),  .oCarry(wCarry[1]), .oR(wResult[0][1]));
                EMUL mul2(.wA(wSourceData1[3] & wSourceData0[0]), .wB(wSourceData1[2] & wSourceData0[1]), .iCarry(wCarry[1]),  .oCarry(wCarry[2]), .oR(wResult[0][2]));
                EMUL mul3(.wA(1'b0), .wB(wSourceData1[3] & wSourceData0[1]), .iCarry(wCarry[2]),  .oCarry(wCarry[3]), .oR(wResult[0][3]));
                EMUL mul4(.wA(wResult[0][1]), .wB(wSourceData1[0] & wSourceData0[2]), .iCarry(1'b0),  .oCarry(wCarry[4]), .oR(wResult[1][0]));
                EMUL mul5(.wA(wResult[0][2]), .wB(wSourceData1[1] & wSourceData0[2]), .iCarry(wCarry[4]),  .oCarry(wCarry[5]), .oR(wResult[1][1]));
                EMUL mul6(.wA(wResult[0][3]), .wB(wSourceData1[2] & wSourceData0[2]), .iCarry(wCarry[5]),  .oCarry(wCarry[6]), .oR(wResult[1][2]));
                EMUL mul7(.wA(wSourceData1[3] & wSourceData0[2]), .wB(wCarry[3]), .iCarry(wCarry[6]),  .oCarry(wCarry[7]), .oR(wResult[1][3]));
                EMUL mul8(.wA(wResult[1][1]), .wB(wSourceData1[0] & wSourceData0[3]), .iCarry(1'b0),  .oCarry(wCarry[8]), .oR(wResult[2][0]));
                EMUL mul9(.wA(wResult[1][2]), .wB(wSourceData1[1] & wSourceData0[3]), .iCarry(wCarry[8]),  .oCarry(wCarry[9]), .oR(wResult[2][1]));
                EMUL mul10(.wA(wResult[1][3]), .wB(wSourceData1[2] & wSourceData0[3]), .iCarry(wCarry[9]),  .oCarry(wCarry[10]), .oR(wResult[2][2]));
                EMUL mul11(.wA(wCarry[7]), .wB(wSourceData1[3] & wSourceData0[3]), .iCarry(wCarry[10]),  .oCarry(wCarry[11]), .oR(wResult[2][3]));



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
           rResult <= {8'b0, wCarry[11], wResult[2][3], wResult[2][2], wResult[2][1], wResult[2][0], wResult[1][0], wResult[0][0], wSourceData1[0] & wSourceData0[0]};
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
