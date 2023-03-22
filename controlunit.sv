module control_unit(
      input logic[3:0] opcode,
      output logic[1:0] alu_op,
      output logic jump,beq,bne,mem_read,mem_write,alu_src,reg_dst,mem_to_reg,reg_write    
    );


always_comb
  begin
 case(opcode) 
 4'b0000:  
   begin
    reg_dst = 1'b0;
    alu_src = 1'b1;
    mem_to_reg = 1'b1;
    reg_write = 1'b1;
    mem_read = 1'b1;
    mem_write = 1'b0;
    beq = 1'b0;
    bne = 1'b0;
    alu_op = 2'b10;
    jump = 1'b0;   
   end
 4'b0001:  
   begin
    reg_dst = 1'b0;
    alu_src = 1'b1;
    mem_to_reg = 1'b0;
    reg_write = 1'b0;
    mem_read = 1'b0;
    mem_write = 1'b1;
    beq = 1'b0;
    bne = 1'b0;
    alu_op = 2'b10;
    jump = 1'b0;   
   end
 4'b0010:  // ALU
   begin
    data_proc_op();   
   end
 4'b0011:  // ALU
   begin
    data_proc_op();  
   end
 4'b0100:  // ALU
   begin
    data_proc_op();   
   end
 4'b0101:  // ALU
   begin
   data_proc_op();   
   end
 4'b0110:  // ALU
   begin
    data_proc_op();   
   end
 4'b0111:  // ALU
   begin
    data_proc_op();   
   end
 4'b1000:  // ALU
   begin
    data_proc_op();   
   end
 4'b1001:  // ALU
   begin
     data_proc_op();   
   end
 4'b1011:  // BEQ
   begin
    branch_op();
    beq = 1'b1;
    bne = 1'b0;
    alu_op = 2'b01;
    jump = 1'b0;   
   end
 4'b1100:  // BNE
   begin
    branch_op();
    beq = 1'b0;
    bne = 1'b1;
    alu_op = 2'b01;
    jump = 1'b0;   
   end
 4'b1101:  // J
   begin
    branch_op();
    beq = 1'b0;
    bne = 1'b0;
    alu_op = 2'b00;
    jump = 1'b1;   
   end   
 default: begin
    data_proc_op(); 
   end
 endcase  
end
  
  task data_proc_op();
    reg_dst = 1'b1;
    alu_src = 1'b0;
    mem_to_reg = 1'b0;
    reg_write = 1'b1;
    mem_read = 1'b0;
    mem_write = 1'b0;
    beq = 1'b0;
    bne = 1'b0;
    alu_op = 2'b00;
    jump = 1'b0;
  endtask
  
  task branch_op();
    reg_dst = 1'b0;
    alu_src = 1'b0;
    mem_to_reg = 1'b0;
    reg_write = 1'b0;
    mem_read = 1'b0;
    mem_write = 1'b0;
  endtask

endmodule
