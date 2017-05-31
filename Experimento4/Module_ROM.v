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
	0: oInstruction = { `NOP, 24'd4000  };
	1: oInstruction = { `STO, `R4, 16'd240 };
	2: oInstruction = { `STO, `R1, 16'd240 };
	6: oInstruction = { `VGA, `R4,`R1   };
	7: oInstruction = { `NOP, 24'd4000  };
		// Incompleto
/*	8: oInstruction = { `STO, `R4, 16'd241 };
	9: oInstruction = { `STO, `R1, 16'd241 };
	10: oInstruction = { `VGA, `R4,`R1   };
	11: oInstruction = { `NOP, 24'd4000  };
	12: oInstruction = { `STO, `R4, 16'd242 };
	13: oInstruction = { `STO, `R1, 16'd242 };
	14: oInstruction = { `NOP, 24'd4000  };
	15: oInstruction = { `STO, `R4, 16'd243 };
	16: oInstruction = { `STO, `R1, 16'd243 };
	17: oInstruction = { `VGA, `R4,`R1   };
	18: oInstruction = { `NOP, 24'd4000  };
	19: oInstruction = { `STO, `R4, 16'd244 };
	20: oInstruction = { `STO, `R1, 16'd244 };
	21: oInstruction = { `VGA, `R4,`R1   };		
*/	22: oInstruction = { `NOP, 24'd4000  };
	23: oInstruction = { `JMP, 8'd0,16'b0};
	default:
		oInstruction = { `LED ,  24'b10101010 };		//NOP
	endcase
end

endmodule
