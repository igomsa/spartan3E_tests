timescale 1ns / 1ps
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
//Se introduce cÃ³digo para realizar instancias de manera automÃ¡tica
//a manera de arreglo de 15x14

wire[16:0] wCarry[16:0];
wire [16:0]wResult[16:0];
   genvar CurrentRow, CurrentCol;
   generate //Permite instanciar varias veces
	//For de las filas.
      for (CurrentRow = 0; CurrentRow < 15; CurrentRow = CurrentRow +1)
        begin: MUL_ROW //Etiqueta de inicio del for de filas
		  //For de las columnas
           for ( CurrentCol = 0; CurrentCol < 16; CurrentCol = CurrentCol + 1)
             begin: MUL_COL //Etiqueta de inicio del for de columnas
				 //La primera columna es un caso especial.
				//Se debe asignar 0 a su valor de iCarry.
                if (CurrentCol == 0)
                  begin
                     assign wCarry[ CurrentRow ][ 0 ] = 0;
                  end//if
						 //La primera fila es un caso especial de conexión,
						 //específicamente en entradas.
                     if (CurrentRow == 0)
                       begin
									if (CurrentCol == 15)
										begin
											EMUL  MyAdder1
											(
											.wA( wSourceData0[CurrentRow+1] & wSourceData1[CurrentCol] ),
											.wB( 1'b0),
											.iCarry( wCarry[ CurrentRow ][ CurrentCol ] ),
											.oCarry( wCarry[ CurrentRow +1 ][ CurrentCol+1]),
											.oR(wResult[CurrentRow][CurrentCol])
											);
										end //else if
										else 
										begin
										EMUL  MyAdder
											(
											.wA( wSourceData0[CurrentRow+1] & wSourceData1[CurrentCol] ),
											.wB( wSourceData0[CurrentRow] & wSourceData1[CurrentCol+1] ),
											.iCarry( wCarry[ CurrentRow ][ CurrentCol ] ),
											.oCarry( wCarry[ CurrentRow ][ CurrentCol + 1]),
											.oR(wResult[ CurrentRow ][ CurrentCol])
											);
									  end
								end //if
								//ultima columna de las demas filas 
							else if (CurrentCol == 15 )
								begin
								EMUL  MyAdder2(
								.wA(wSourceData0[CurrentRow+1]&wSourceData1[CurrentCol] ),
								.wB( wCarry[ CurrentRow  ][ CurrentCol ] ),
								.iCarry( wCarry[ CurrentRow ][ CurrentCol ] ),
								.oCarry( wCarry[ CurrentRow +1][ CurrentCol +1]),
								.oR(wResult[ CurrentRow ][ CurrentCol ])
								);
							end//else if
							// La última columna es un caso especial de conexión.
              
             //Filas y columnas típicas
                else
                  begin
                     EMUL  MyAdder
                       (
                        .wA( wSourceData0[CurrentRow +1] & wSourceData1[CurrentCol] ),
                        .wB( wResult[CurrentRow -1][CurrentCol +1] ),
                        .iCarry( wCarry[ CurrentRow ][ CurrentCol ] ),
                        .oCarry( wCarry[ CurrentRow ][ CurrentCol + 1]),
                        .oR(wResult[CurrentRow][CurrentCol])
                        );
                  end //else
             end //For Col
        end //For Row
endgenerate

//----------------------------------------------------------------------

always @ (*) 
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

           //rResult <= {8'b0, wResult[6][0], wResult[5][0], wResult[4][0], wResult[3][0], wResult[2][0], wResult[1][0], wResult[0][0], wSourceData1[0] & wSourceData0[0]};


          // rResult <= {8'b0, wResult[14][0], wResult[13][0], wResult[12][0], wResult[11][0], wResult[10][0], wResult[9][0], wResult[8][0], wResult[7][0]};

        //   rResult <= {8'b0, wResult[14][8], wResult[14][7], wResult[14][6], wResult[14][5], wResult[14][4], wResult[14][3], wResult[14][2], wResult[14][1]};

        rResult <= {8'b0, wCarry[15][16], wResult[14][15], wResult[14][14], wResult[14][13], wResult[14][12], wResult[14][11], wResult[14][10], wResult[14][9]};

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
