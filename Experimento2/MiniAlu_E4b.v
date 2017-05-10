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

   //Register ENMUL: Habilitador de contador para mostrar resultado de MUL.
   //Register rResetMUL: Reinicia la cuenta del contador.
   //Wire [1:0] i: Lleva la cuenta.
   wire   [1:0]  i;
   reg      rResetMUL;
   reg      ENMUL;


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

   //Contador para mostrar resultado en de 32 bits
UPCOUNTER_POSEDGE counter0
(
.Clock(   Clock                ),
.Reset(   rResetMUL ),
.Initial( 1'b0  ),
.Enable(  ENMUL                 ),
.Q(       i             )
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

   //Resultados parciales de multiplicación por MUX.
wire [17:0]   wParcialRes0, wParcialRes1, wParcialRes2, wParcialRes3;
wire [17:0]   wParcialRes4,   wParcialRes5, wParcialRes6, wParcialRes7;

   //Resultados parciales de las sumas.
wire [20:0]   wParcialRes8, wParcialRes9, wParcialRes10, wParcialRes11;
wire [22:0]   wParcialRes12, wParcialRes13;

   //Resultado final de la multiplicación de AxB.
wire [31:0] wResult;

   //Se introducen en las funciones MUX los resultados correspondientes a cada caso posible del selector.
   // Dado que son numeros de 16 bits, son necesarios 8 muxes.
		mux mux0(.wcase0(19'b0), .wcase1({3'b0, wsourcedata1}), .wcase2({2'b0, wSourceData1, 1'b0}), .wCase3({2'b0, wSourceData1, 1'b0} + wSourceData1), .wSelection(wSourceData0[1:0]), .oR(wParcialRes0[17:0]) );
		mux mux1(.wcase0(19'b0), .wcase1({3'b0, wsourcedata1}), .wcase2({2'b0, wSourceData1, 1'b0}), .wCase3({2'b0, wSourceData1, 1'b0} + wSourceData1), .wSelection(wSourceData0[3:2]), .oR(wParcialRes1[17:0]) );
		mux mux2(.wcase0(19'b0), .wcase1({3'b0, wsourcedata1}), .wcase2({2'b0, wSourceData1, 1'b0}), .wCase3({2'b0, wSourceData1, 1'b0} + wSourceData1), .wSelection(wSourceData0[5:4]), .oR(wParcialRes2[17:0]) );
		mux mux3(.wcase0(19'b0), .wcase1({3'b0, wsourcedata1}), .wcase2({2'b0, wSourceData1, 1'b0}), .wCase3({2'b0, wSourceData1, 1'b0} + wSourceData1), .wSelection(wSourceData0[7:6]), .oR(wParcialRes3[17:0]) );
		mux mux4(.wcase0(19'b0), .wcase1({3'b0, wsourcedata1}), .wcase2({2'b0, wSourceData1, 1'b0}), .wCase3({2'b0, wSourceData1, 1'b0} + wSourceData1), .wSelection(wSourceData0[9:8]), .oR(wParcialRes4[17:0]) );
		mux mux5(.wcase0(19'b0), .wcase1({3'b0, wsourcedata1}), .wcase2({2'b0, wSourceData1, 1'b0}), .wCase3({2'b0, wSourceData1, 1'b0} + wSourceData1), .wSelection(wSourceData0[11:10]), .oR(wParcialRes5[17:0]) );
		mux mux6(.wcase0(19'b0), .wcase1({3'b0, wsourcedata1}), .wcase2({2'b0, wSourceData1, 1'b0}), .wCase3({2'b0, wSourceData1, 1'b0} + wSourceData1), .wSelection(wSourceData0[13:12]), .oR(wParcialRes6[17:0]));
		mux mux7(.wcase0(19'b0), .wcase1({3'b0, wsourcedata1}), .wcase2({2'b0, wSourceData1, 1'b0}), .wCase3({2'b0, wSourceData1, 1'b0} + wSourceData1), .wSelection(wSourceData0[15:14]), .oR(wParcialRes7[17:0]) );

// Se llevan a cabo las sumas parciales de los resultados obtenidos en los muxes.
	// Sumas con corrimiento de 2 bits
		EMUL mul0(.wA({14'b0, wParcialRes0[17:0]}), .wB({12'b0, wParcialRes1[17:0], 2'b0}), .iCarry(1'b0), .oCarry(), .oR(wParcialRes8[20:0]));
		EMUL mul1(.wA({14'b0, wParcialRes2[17:0]}), .wB({12'b0, wParcialRes3[17:0], 2'b0}), .iCarry(1'b0), .oCarry(), .oR(wParcialRes9[20:0]));
		EMUL mul2(.wA({14'b0, wParcialRes4[17:0]}), .wB({12'b0, wParcialRes5[17:0], 2'b0}), .iCarry(1'b0), .oCarry(), .oR(wParcialRes10[20:0]));
		EMUL mul3(.wA({14'b0, wParcialRes6[17:0]}), .wB({12'b0, wParcialRes7[17:0], 2'b0}), .iCarry(1'b0), .oCarry(), .oR(wParcialRes11[20:0]));
	//Sumas con crimiento de 4 bits. (sumas de los resultados de las sumas)
		EMUL mul4(.wA({13'b0, wParcialRes8[18:0]}), .wB({10'b0, wParcialRes9[18:0], 4'b0}), .iCarry(1'b0), .oCarry(), .oR(wParcialRes12[22:0]));
		EMUL mul5(.wA({13'b0, wParcialRes10[18:0]}), .wB({10'b0, wParcialRes11[18:0], 4'b0}), .iCarry(1'b0), .oCarry(), .oR(wParcialRes13[22:0]));
	// Sumas con rrimientos de 8 bits, suma final.
		EMUL mul6(.wA({9'b0, wParcialRes12[22:0]}), .wB({6'b0, wParcialRes13[22:0], 8'b0}), .iCarry(1'b0), .oCarry(), .oR(wResult[31:0]));


//Condiciones iniciales para evitar condiciones X.
   initial
     begin
        rResetMUL <= 0;
        ENMUL <= 0;
     end

always @ ( * )
begin
	case (wOperation)
	//-------------------------------------
	`NOP:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b0;
           ENMUL <= 0;
		rResult      <= 0;
	end
	//-------------------------------------
	`ADD:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
           ENMUL <= 0;
		rResult   <= wSourceData1 + wSourceData0;
	end
        //-------------------------------------
	`SUB:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
           ENMUL <= 0;
		rResult   <= wSourceData1 - wSourceData0;

	end
        //-------------------------------------

	`MUL:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
                rResetMUL <= 0;
                ENMUL <= 1;

           //Con respecto al contador se asigna el resultado.
          if (i==0)
               begin
	          rResult <= {8'b0, wResult[7:0]};
               end
           else if (i==1)
                begin
                   rResult <= {8'b0, wResult[15:8]};
               end
           else if (i==2)
                begin
                   rResult <= {8'b0, wResult[23:16]};
               end
           else if (i==3)
                begin
                   rResult <= {8'b0, wResult[31:24]};
               end
           else
                begin
                  rResetMUL <= 1;
               end
	end
	//-------------------------------------
	`STO:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b1;
		rBranchTaken <= 1'b0;
           ENMUL <= 0;
		rResult      <= wImmediateValue;
	end
	//-------------------------------------
	`BLE:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
           ENMUL <= 0;
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
           ENMUL <= 0;
		rBranchTaken <= 1'b1;
	end
	//-------------------------------------
	`LED:
	begin
		rFFLedEN     <= 1'b1;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
           ENMUL <= 0;
		rBranchTaken <= 1'b0;
	end
	//-------------------------------------
	default:
	begin
		rFFLedEN     <= 1'b1;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b0;
           ENMUL <= 0;
	end
	//-------------------------------------
	endcase
end


endmodule
