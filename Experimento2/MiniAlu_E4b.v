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
wire [17:0]   wParcialRes0, wParcialRes1, wParcialRes2, wParcialRes3;
wire [17:0]   wParcialRes4,   wParcialRes5, wParcialRes6, wParcialRes7;
wire [20:0]   wParcialRes8, wParcialRes9, wParcialRes10, wParcialRes11;
wire [22:0]   wParcialRes12, wParcialRes13;
wire [31:0] wResult;


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

		MUX 		mux0(.wCase0(18'b0), .wCase1(wSourceData1), .wCase2({1'b0, wSourceData1, 1'b0}), .wCase3({wSourceData1, 1'b0} + wSourceData1), .wSelection(wSourceData0[1:0]), .oR(wParcialRes0[17:0]) );
		MUX 		mux1(.wCase0(18'b0), .wCase1(wSourceData1), .wCase2({1'b0, wSourceData1, 1'b0}), .wCase3({1'b0, wSourceData1, 1'b0} + wSourceData1), .wSelection(wSourceData0[3:2]), .oR(wParcialRes1[17:0]) );
		MUX 		mux2(.wCase0(18'b0), .wCase1(wSourceData1), .wCase2({1'b0, wSourceData1, 1'b0}), .wCase3({1'b0, wSourceData1, 1'b0} + wSourceData1), .wSelection(wSourceData0[5:4]), .oR(wParcialRes2[17:0]) );
		MUX 		mux3(.wCase0(18'b0), .wCase1(wSourceData1), .wCase2({1'b0, wSourceData1, 1'b0}), .wCase3({1'b0, wSourceData1, 1'b0} + wSourceData1), .wSelection(wSourceData0[7:6]), .oR(wParcialRes3[17:0]) );
		MUX 		mux4(.wCase0(18'b0), .wCase1(wSourceData1), .wCase2({1'b0, wSourceData1, 1'b0}), .wCase3({1'b0, wSourceData1, 1'b0} + wSourceData1), .wSelection(wSourceData0[9:8]), .oR(wParcialRes4[17:0]) );
		MUX 		mux5(.wCase0(18'b0), .wCase1(wSourceData1), .wCase2({1'b0, wSourceData1, 1'b0}), .wCase3({1'b0, wSourceData1, 1'b0} + wSourceData1), .wSelection(wSourceData0[11:10]), .oR(wParcialRes5[17:0]) );
		MUX 		mux6(.wCase0(18'b0), .wCase1(wSourceData1), .wCase2({1'b0, wSourceData1, 1'b0}), .wCase3({1'b0, wSourceData1, 1'b0} + wSourceData1), .wSelection(wSourceData0[13:12]), .oR(wParcialRes6[17:0]));
		MUX 		mux7(.wCase0(18'b0), .wCase1(wSourceData1), .wCase2({1'b0, wSourceData1, 1'b0}), .wCase3({1'b0, wSourceData1, 1'b0} + wSourceData1), .wSelection(wSourceData0[15:14]), .oR(wParcialRes7[17:0]) );


		EMUL 		mul0(.wA(wParcialRes0[17:0]), .wB({wParcialRes1[17:0], 2'b0}), .iCarry(1'b0), .oCarry(), .oR(wParcialRes8[20:0]));
		EMUL 		mul1(.wA(wParcialRes2[17:0]), .wB({wParcialRes3[17:0], 2'b0}), .iCarry(1'b0), .oCarry(), .oR(wParcialRes9[20:0]));
		EMUL 		mul2(.wA(wParcialRes4[17:0]), .wB({wParcialRes5[17:0], 2'b0}), .iCarry(1'b0), .oCarry(), .oR(wParcialRes10[20:0]));
		EMUL 		mul3(.wA(wParcialRes6[17:0]), .wB({wParcialRes7[17:0], 2'b0}), .iCarry(1'b0), .oCarry(), .oR(wParcialRes11[20:0]));

		EMUL 		mul4(.wA(wParcialRes8[18:0]), .wB({wParcialRes9[18:0], 4'b0}), .iCarry(1'b0), .oCarry(), .oR(wParcialRes12[22:0]));
		EMUL 		mul5(.wA(wParcialRes10[18:0]), .wB({wParcialRes11[18:0], 4'b0}), .iCarry(1'b0), .oCarry(), .oR(wParcialRes13[22:0]));

		EMUL 		mul6(.wA(wParcialRes12[22:0]), .wB({wParcialRes13[22:0], 8'b0}), .iCarry(1'b0), .oCarry(), .oR(wResult[31:0]));

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
	//rResult 		<= {8'b0, wResult};
  //rResult 		<= {8'b0, wResult >> 8};
  //rResult 		<= {8'b0, wResult >> 16};
  rResult 		<= {8'b0, wResult >> 24};

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
