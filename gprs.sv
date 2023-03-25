`include "parameters.sv"
`timescale 1ns / 1ps

module GPRs(
  input bit clk,
  
  input logic write_en,
  input logic [2:0] write_dest,          //Destination Register
  input logic [15:0] write_data,         //16-bit Data in the destination register 
  
  input logic [2:0] read_addr_1,         // Adress of the register
  input logic [2:0] read_addr_2,
  
  output logic [15:0] read_data_1,      //16-bit Data in the register
  output logic [15:0] read_data_2
);
  
  logic [15:0] register_array [7:0];     //An array of registers
  
 initial begin
   for(int i=0;i<8;i=i+1)
     register_array[i] <= 16'd1;
 end
 always @ (posedge clk ) begin
   if(write_en) begin
     register_array[write_dest] <= write_data;             //Write the data to destination register when write_en is high
   end
 end
 

  assign read_data_1 = register_array[read_addr_1];              
  assign read_data_2 = register_array[read_addr_2];    


endmodule
