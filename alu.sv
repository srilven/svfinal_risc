module ALU(
  input  logic [15:0] src_1,  
  input  logic [15:0] src_2,  
  input  logic [3:0] alu_control, 
 
  output logic [15:0] result,  
 output logic zero
    );

  always_comb
begin 
 case(alu_control)
 4'b0000: result = src_1 + src_2; 
 4'b0001: result = src_1 - src_2; 
 4'b0010: result = ~src_1;
 4'b0011: result = src_1 << src_2;
 4'b0100: result = src_1 >> src_2;
 4'b0101: result = src_1 & src_2; 
 4'b0110: result = src_1 | src_2; 
 4'b0111: result = src_1 + 1; 
 4'b1000: result = src_1 - 1; 
 default:result = src_1 + src_2; 
   
 endcase
end
  
assign zero = (result==16'd0) ? 1'b1: 1'b0;
 
endmodule
