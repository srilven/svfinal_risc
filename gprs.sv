module GPRs(
  input bit clk,
  
  input logic write_en,
  input logic [2:0] write_dest,
  input logic [15:0] write_data,
  
  input logic [2:0] read_addr_1,
  input logic [2:0] read_addr_2,
  
  output logic [15:0] read_data_1,
  output logic [15:0] read_data_2
);
  
  logic [15:0] register_array [7:0];
  
 integer i;
 
 initial begin
  for(i=0;i<8;i=i+1)
    register_array[i] <= 16'd1;
 end
 always @ (posedge clk ) begin
   if(write_en) begin
    register_array[write_dest] <= write_data;
   end
 end
 

 assign read_data_1 = register_array[read_addr_1];
 assign read_data_2 = register_array[read_addr_2];


endmodule
