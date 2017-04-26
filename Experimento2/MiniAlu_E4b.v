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
wire [127:0]   wCarry;
wire [45:0] wResultParcial;
wire [143:0] wResult;

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

		MUX 		mux0(.wCase0(18'b0), .wCase1(wSourceData1), .wCase2({1'b0, wSourceData1, 1'b0}), .wCase3({wSourceData1, 1'b0} + wSourceData1), .wSelection(wSourceData0[1:0]), .oR(wResult[17:0]) );
		MUX 		mux1(.wCase0(18'b0), .wCase1(wSourceData1), .wCase2({1'b0, wSourceData1, 1'b0}), .wCase3({1'b0, wSourceData1, 1'b0} + wSourceData1), .wSelection(wSourceData0[3:2]), .oR(wResult[35:18]) );
		MUX 		mux2(.wCase0(18'b0), .wCase1(wSourceData1), .wCase2({1'b0, wSourceData1, 1'b0}), .wCase3({1'b0, wSourceData1, 1'b0} + wSourceData1), .wSelection(wSourceData0[5:4]), .oR(wResult[53:36]) );
		MUX 		mux3(.wCase0(18'b0), .wCase1(wSourceData1), .wCase2({1'b0, wSourceData1, 1'b0}), .wCase3({1'b0, wSourceData1, 1'b0} + wSourceData1), .wSelection(wSourceData0[7:6]), .oR(wResult[71:54]) );
		MUX 		mux4(.wCase0(18'b0), .wCase1(wSourceData1), .wCase2({1'b0, wSourceData1, 1'b0}), .wCase3({1'b0, wSourceData1, 1'b0} + wSourceData1), .wSelection(wSourceData0[9:8]), .oR(wResult[89:72]) );
		MUX 		mux5(.wCase0(18'b0), .wCase1(wSourceData1), .wCase2({1'b0, wSourceData1, 1'b0}), .wCase3({1'b0, wSourceData1, 1'b0} + wSourceData1), .wSelection(wSourceData0[11:10]), .oR(wResult[107:90]) );
		MUX 		mux6(.wCase0(18'b0), .wCase1(wSourceData1), .wCase2({1'b0, wSourceData1, 1'b0}), .wCase3({1'b0, wSourceData1, 1'b0} + wSourceData1), .wSelection(wSourceData0[12:11]), .oR(wResult[125:108]) );
		MUX 		mux7(.wCase0(18'b0), .wCase1(wSourceData1), .wCase2({1'b0, wSourceData1, 1'b0}), .wCase3({1'b0, wSourceData1, 1'b0} + wSourceData1), .wSelection(wSourceData0[14:13]), .oR(wResult[143:126]) );


		EMUL 		mul0(.wA(wResult[17:0]), .wB({wResult[35:18], 2'b0}), .iCarry(1'b0), .oCarry(), .oR(wCarry[31:0])); 
		EMUL 		mul1(.wA(wResult[53:36]), .wB({wResult[71:54], 2'b0}), .iCarry(1'b0), .oCarry(), .oR(wCarry[63:32]));
		EMUL 		mul2(.wA(wResult[89:72]), .wB({wResult[107:90], 2'b0}), .iCarry(1'b0), .oCarry(), .oR(wCarry[95:64])); 
		EMUL 		mul3(.wA(wResult[125:108]), .wB({wResult[143:126], 2'b0}), .iCarry(1'b0), .oCarry(), .oR(wCarry[127:96]));  

		EMUL 		mul4(.wA(wCarry[20:0]), .wB({wCarry[41:21], 4'b0}), .iCarry(1'b0), .oCarry(), .oR(wResultParcial[22:0])); 
		EMUL 		mul5(.wA(wCarry[62:42]), .wB({wCarry[83:63], 4'b0}), .iCarry(1'b0), .oCarry(), .oR(wResultParcial[45:23])); 

		EMUL 		mul6(.wA(wResultParcial[22:0]), .wB({wResultParcial[45:23], 8'b0}), .iCarry(1'b0), .oCarry(), .oR(wResult[31:0])); 

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
	rResult 		<= {8'b0, wCarry};
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
