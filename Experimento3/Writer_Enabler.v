`timescale 1ns / 1ps
`define STATE_ENAB 		0
`define SET_UP_ENAB		1
`define SET_DOWN_ENAB	2
`define	WRITE_DONE		3

module Module_Write_Enable
(
	input wire iReset,
	input wire Clock,
	input wire oLCD_ReadWrite,
	input wire oLCD_RegisterSelect,
	output wire oLCD_Enabled,
	output reg rEnableDone);
reg [31:0] rCount;
reg [3:0] rActualState;
assign rCount = 32'b0;
always @(posedge Clock )
 begin
	rCount= rCount + 32'b1;
 end

always @( oLCD_RegisterSelect )
 begin
 	case(rActualState)
 	//---------------------------------------
 	`STATE_ENAB:
 	begin
 		oLCD_Enabled = 1'b0;
 		rEnableDone  = 1'b0;
 		if (rCount > 32'd2 )		//se mantiene enalble en 0 por 40ns
 		 begin
 		 rActualState = `SET_UP_ENAB;
 		 rCount = 32'b0;
 		 end
 		else
 		 begin
 		  rActualState= `STATE_ENAB;
 		   
 		 end
 	end
 	//-----------------------------------------
 	`SET_UP_ENAB:
 	begin
 	 	oLCD_Enabled = 1'b1;
 		rEnableDone  = 1'b0;			
 		if (rCount > 32'd12 )		//se mantiene enable por 240ns 
 		 begin
 			rActualState = `SET_DOWN_ENAB;
 			rCount = 32'b0;
 		 end
 		else
 		 begin
 			rActualState = `SET_UP_ENAB;
 			
  		 end
 	end
 	//--------------------------------------------
 	`SET_DOWN_ENAB:
 	begin
 		oLCD_Enabled = 1'b0;
 		rEnableDone = 1'b0;
 		if (rCount > 1'b1 )		// se mantiene enable por 20ns 
 		 begin
 			rActualState = `WRITE_DONE;
 			rCount = 1'b0;
 		 end
 		else
 		 begin
 			rActualState = `SET_DOWN_ENAB;
 			
 		 end
 	end
 	//----------------------------------------------
 	`WRITE_DONE:
 	begin
 		oLCD_Enabled = 1'b0;
 		rEnableDone = 1'b1;			//se setea EnableDone para terminar
 	end
 end

endmodule
