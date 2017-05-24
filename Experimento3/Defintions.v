`timescale 1ns / 1ps
`ifndef DEFINTIONS_V
`define DEFINTIONS_V

`default_nettype none
`define NOP   4'd0
`define SUB   4'd1
`define LCD   4'd2
`define BLE   4'd3
`define STO   4'd4
`define ADD   4'd5
`define JMP   4'd6
`define MUL   4'd7
`define SHL   4'd8


//Se agregan para implementar las funciones LCD y SHL, CALL, RET.
`define LCD   4'd8
`define SHL   4'd9
`define CALL  4'd10
`define RET   4'd11

// Registros
`define R0 8'd0
`define R1 8'd1
`define R2 8'd2
`define R3 8'd3
`define R4 8'd4
`define R5 8'd5
`define R6 8'd6
`define R7 8'd7

// Se agregan para añadir las letras respectivas a la frase "Hola Mundo". 
// Se definen las letras con la respectiva representacion ASCII.
`define H	16'b01001000
`define o	16'b01101111
`define l	16'b01101100
`define a	16'b01100001
`define M	16'b01001101
`define u	16'b01110101
`define n	16'b01101110
`define d	16'b01100100
`define Space 16'b00100000

`endif
