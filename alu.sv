`include "parameters.sv"
`timescale 1ns / 1ps
module ALU(
  input  logic [15:0] src_1,            //Operand-1
  input  logic [15:0] src_2,            //Operand-2
  input  logic [3:0] alu_control,      //function select
 
  output logic [15:0] result,           //result 
 output logic zero
    );

  always_comb
begin
 case(alu_control)
 4'b0000: result = src_1 + src_2;          // addition
 4'b0001: result = src_1 - src_2;         // subtraction
 4'b0010: result = ~src_1;                //Inversion
 4'b0011: result = src_1 << src_2;        //Left shift
 4'b0100: result = src_1 >> src_2;        //Right shift
 4'b0101: result = src_1 & src_2;         // and
 4'b0110: result = src_1 | src_2;        // or
 4'b0111: result = src_1 + 1;           // inc by 1
 4'b1000: result = src_1 - 1;          // dec by 1  
 default:result = src_1 + src_2;      // add
   
 endcase
end
  
  assign zero = (result==16'd0) ? 1'b1: 1'b0;   //If branch equals zero=1 else zero=0
 
endmodule
