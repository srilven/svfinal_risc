`timescale 1ns / 1ps

module alu_control( ALU_Cnt, ALUOp, Opcode);
  output logic [3:0] ALU_Cnt;
  input logic [1:0] ALUOp;
  input logic [3:0] Opcode;
  logic [5:0] ALUControlIn;
  assign ALUControlIn = {ALUOp,Opcode};
  always_comb
    casex (ALUControlIn)
   6'b10xxxx: ALU_Cnt=4'b0000;
   6'b01xxxx: ALU_Cnt=4'b0001;
   6'b000010: ALU_Cnt=4'b0000;
   6'b000011: ALU_Cnt=4'b0001;
   6'b000100: ALU_Cnt=4'b0010;
   6'b000101: ALU_Cnt=4'b0011;
   6'b000110: ALU_Cnt=4'b0100;
   6'b000111: ALU_Cnt=4'b0101;
   6'b001000: ALU_Cnt=4'b0110;
   6'b001001: ALU_Cnt=4'b0111;
   6'b001010: ALU_Cnt=4'b1000;
  default: ALU_Cnt=4'b0000;
  endcase
endmodule
