module data_memory(
 input bit clk,
 
  input logic [15:0]   addr,
 
 input logic [15:0]   write_data,
 input logic write_en,
 input logic read_en,
 // read port
 output logic [15:0]   read_data
);

  logic [`data_column - 1:0] memory [`data_row - 1:0];
  
  initial
    begin
      $readmemb("datamem.txt", memory);
 end
 
   always_ff @(posedge clk) begin
  if (write_en)
    memory[addr] <= write_data;
 end
  assign read_data = (read_en==1'b1) ? memory[addr]: 16'd0; 

endmodule
