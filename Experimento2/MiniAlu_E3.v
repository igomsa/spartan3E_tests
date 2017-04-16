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
wire [10:0]   wCarry;
wire [5:0] wResult;
output reg [15:0] rVars;




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
		rResult[0]   <= wSourceData1[0] & wSourceData0[0];
                rVars[0] <= wSourceData1[0] & wSourceData0[1];
                rVars[1] <= wsourcedata1[1] & wsourcedata0[0];
                rVars[2] <= wSourceData1[2] & wSourceData0[0];
                rVars[3] <= wSourceData1[1] & wSourceData0[1];
                rVars[4] <= wSourceData1[3] & wSourceData0[0];
                rVars[5] <= wSourceData1[2] & wSourceData0[1];
                rVars[6] <= 1'b0;
                rVars[7] <= wSourceData1[3] & wSourceData0[1];
                rVars[8] <= wSourceData1[0] & wSourceData0[2];
                rVars[9] <= wSourceData1[1] & wSourceData0[2];
                rVars[10] <= wSourceData1[2] & wSourceData0[2];
                rVars[11] <= wSourceData1[3] & wSourceData0[2];
                rVars[12] <= wSourceData1[0] & wSourceData0[3];
                rVars[13] <= wSourceData1[1] & wSourceData0[3];
                rVars[14] <= wSourceData1[2] & wSourceData0[3];
                rVars[15] <= wSourceData1[3] & wSourceData0[3];
                EMUL mulr(.wA(rVars[0]), .wB(rVars[1]), .iCarry(rVars[6]), .Clock(Clock), .oCarry(wCarry[0]), .rR(rResult[1]));
                EMUL mul2(.wA(rVars[2]), .wB(rVars[3]), .iCarry(wCarry[0]), .Clock(Clock), .oCarry(wCarry[1]), .rR(wResutl[0]));
                EMUL mul3(.wA(rVars[4]), .wB(rVars[5]), .iCarry(wCarry[1]), .Clock(Clock), .oCarry(wCarry[2]), .rR(wResult[1]));
                EMUL mul4(.wA(rVars[6]), .wB(rVars[7]), .iCarry(wCarry[2]), .Clock(Clock), .oCarry(wCarry[3]), .rR(wResult[2]));
                EMUL mul5(.wA(wResult[0]), .wB(rVars[8]), .iCarry(1'b0), .Clock(Clock), .oCarry(wCarry[4]), .rR(rResult[2]));
                EMUL mul6(.wA(wResult[1]), .wB(rVars[9]), .iCarry(wCarry[4]), .Clock(Clock), .oCarry(wCarry[5]), .rR(wResult[3]));
                EMUL mul7(.wA(wResult[2]), .wB(rVars[10]), .iCarry(wCarry[5]), .Clock(Clock), .oCarry(wCarry[6]), .rR(wResult[4]));
                EMUL mul8(.wA(rVars[11]), .wB(wCarry[3]), .iCarry(wCarry[6]), .Clock(Clock), .oCarry(wCarry[7]), .rR(wResult[5]));
                EMUL mul9(.wA(wResult[3]), .wB(rVars[12]), .iCarry(1'b0), .Clock(Clock), .oCarry(wCarry[8]), .rR(rResult[3]));
                EMUL mul10(.wA(wResult[4]), .wB(rVars[13]), .iCarry(wCarry[8]), .Clock(Clock), .oCarry(wCarry[9]), .rR(rResult[4]));
                EMUL mul11(.wA(wResult[5]), .wB(rVars[14]), .iCarry(wCarry[9]), .Clock(Clock), .oCarry(wCarry10), .rR(rResult[5]));
                EMUL mul12(.wA(wCarry[7]), .wB(rVars[15]), .iCarry(wCarry[10]), .Clock(Clock), .oCarry(rResult[7]), .rR(rResult[6]));
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
