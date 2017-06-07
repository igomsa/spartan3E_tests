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
	0: oInstruction  = { `NOP, 24'd4000     };
        
	1: oInstruction  = { `STO, `R0, 16'd250 };
	2: oInstruction  = { `STO, `R1, 16'd250 }; \\ Define las posiciones maximas
	3: oInstruction  = { `STO, `R2, 1 };
	
	4: oInstruction  = { `STO, `R3, 16'd240 };	
	5: oInstruction  = { `STO, `R4, 16'd240 }; \\Posiciones iniciales
		
	6: oInstruction = { `NOP, 24'd4000  	};
	7: oInstruction  = { `VGA, `COLOR_GREEN, `R3,`R4}; \\Color Verde en posicion actual
	8: oInstruction = { `NOP, 24'd4000  	};
		
	9: oInstruction  = { `ADD, `R4, 1 };
	10: oInstruction  = { `BLE, 16'd6, `R4, `R0}; \\ Salta si Columna menor a valor maximo
	11: oInstruction  = { `ADD, `R3, 1 };
	12: oInstruction  = { `BLE, 16'd5, `R4, `R0}; \\ Salta si fila menor a valor maximo	
		

	13: oInstruction = { `JMP, 8'd0,16'b0	};
	default:
		oInstruction = { `LED ,  24'b10101010 };		//NOP
	endcase
end

endmodule
