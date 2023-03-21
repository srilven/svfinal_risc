`include "parameters.sv"
`timescale 1ns / 1ps

module instruction_memory(
 input logic [15:0] pc,
 output logic [15:0] instruction
);

  reg [`inst_number - 1:0] inst_mem [`inst - 1:0];
  
  initial
    begin
      `ifndef RANDOM_INSTRUCTION_INPUT
      $readmemb("instruct.txt", inst_mem,0,14);
      `endif
    end
  
  assign instruction = inst_mem[pc[3:0]];

endmodule

