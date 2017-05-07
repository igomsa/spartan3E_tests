`timescale 1ns / 1ps
`include "Defintions.v"

`define LOOP1 8'd8
`define LOOP2 8'd5
module ROM
(
	input  wire[15:0]  		iAddress,
	output reg [27:0] 		oInstruction
);
always @ ( iAddress )
begin
	case (iAddress)

//LOOP1:
	0: oInstruction = { `NOP ,24'd4000     };
	1: oInstruction = { `STO, `R0,16'd32768  };
	2: oInstruction = { `STO, `R1,16'd32760   };
	3: oInstruction = { `NOP ,24'd4000     };
	4: oInstruction = { `MUL ,`R0,`R0,`R1  };
	5: oInstruction = { `NOP ,24'd5000     };
	6: oInstruction = { `LED ,8'b0,`R0,8'b0};
	7: oInstruction = { `JMP ,  8'd0,16'b0 };
	default:
		oInstruction = { `LED ,  24'b10101010 };		//NOP
	endcase
end

endmodule
