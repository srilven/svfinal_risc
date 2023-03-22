`timescale 1ns / 1ps
`include "parameters.sv"

module datapath_unit(
 input bit clk,
 input logic jump,beq,mem_read,mem_write,alu_src,reg_dst,mem_to_reg,reg_write,bne,
 input logic [1:0] alu_op,
 output logic [3:0] opcode
);
 logic  [15:0] pc_current;
  logic [15:0] pc_next,pc1;
 logic [15:0] instr;
 logic [2:0] reg_write_dest;
 logic [15:0] reg_write_data;
 logic [2:0] reg_read_addr_1;
 logic [15:0] reg_read_data_1;
 logic [2:0] reg_read_addr_2;
 logic [15:0] reg_read_data_2;
 logic [15:0] ext_im,read_data2;
  logic [3:0] ALU_Control;
 logic [15:0] ALU_out;
 logic zero_flag;
  logic [15:0] PC_j, PC_beq, PC_1beq,PC_1bne,PC_bne;
 logic beq_control;
 logic [12:0] jump_shift;
 logic [15:0] mem_read_data;
 // PC 
 initial begin
  pc_current <= 16'd0;
 end
 always @(posedge clk)
 begin 
   pc_current <= pc_next;
 end
 assign pc1 = pc_current + 16'd1;
 // instrution memory
 instruction_memory im(.pc(pc_current),.instruction(instr));
 
 // multiplexer regdest
 assign reg_write_dest = (reg_dst==1'b1) ? instr[5:3] :instr[8:6];
 // register file
 assign reg_read_addr_1 = instr[11:9];
 assign reg_read_addr_2 = instr[8:6];

 // GENERAL PURPOSE REGISTERs
 GPRs reg_file
 (
  .clk(clk),
  .write_en(reg_write),
  .write_dest(reg_write_dest),
  .write_data(reg_write_data),
  .read_addr_1(reg_read_addr_1),
  .read_data_1(reg_read_data_1),
  .read_addr_2(reg_read_addr_2),
  .read_data_2(reg_read_data_2)
 );
 // immediate extend
 assign ext_im = {{10{instr[5]}},instr[5:0]};  
 // ALU control unit
 alu_control ALU_Control_unit(.ALUOp(alu_op),.Opcode(instr[15:12]),.ALU_Cnt(ALU_Control));
 // multiplexer alu_src
 assign read_data2 = (alu_src==1'b1) ? ext_im : reg_read_data_2;
 // ALU 
  ALU alu_unit(.src_1(reg_read_data_1),.src_2(read_data2),.alu_control(ALU_Control),.result(ALU_out),.zero(zero_flag));
 // PC beq add
 assign PC_beq = pc1 + {ext_im[14:0],1'b0};
 assign PC_bne = pc1 + {ext_im[14:0],1'b0};
 // beq control
 assign beq_control = beq & zero_flag;
 assign bne_control = bne & (~zero_flag);
 // PC_beq
  assign PC_1beq = (beq_control==1'b1) ? PC_beq : pc1;
 // PC_bne
  assign PC_1bne = (bne_control==1'b1) ? PC_bne : PC_1beq;
 // PC_j
  assign PC_j = {4'b0000,instr[11:0]};
 // PC_next
  assign pc_next = (jump == 1'b1) ? PC_j :  PC_1bne;

 /// Data memory
  data_memory dm
   (
    .clk(clk),
    .addr(ALU_out),
    .write_data(reg_read_data_2),
    .write_en(mem_write),
    .read_en(mem_read),
    .read_data(mem_read_data)
   );
 
 // write back
 assign reg_write_data = (mem_to_reg == 1'b1)?  mem_read_data: ALU_out;
 // output to control unit
 assign opcode = instr[15:12];
endmodule