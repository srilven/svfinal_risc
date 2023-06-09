`include "parameters.sv"
`timescale 1ns / 1ps

package random_pkg;
class random_instruction;
  rand logic [3:0] opcode;
  rand logic [2:0] src1;
  rand logic [2:0] src2;
  rand logic [2:0] dest1;
  rand logic [5:0] offset;
  logic [`instruction_row - 1:0] instruct; 
  
  constraint opcode_c { opcode inside {[0:13]}; }
  constraint offset_c { offset inside {[0:1]};  }
  
  function void post_randomize();                     //using post randomize
    if(opcode inside {[2:10]})										//for alu operations
          instruct = {opcode,dest1,src1,src2,offset[2:0]};
        else if(opcode inside {0, 1, 11, 12})							//for mem and branch operation
          instruct = {opcode,dest1,src1,offset};
        else if(opcode == 13)											//for jump
           instruct = {opcode,6'b000000,offset};
        $display("time=%t, random opcode=%d, src1=%b, src2=%b, dest1=%d, offset=%b instruction=%b", $time, opcode, dest1, src1, src2, offset, instruct);
  endfunction
  
endclass
endpackage

module top_risc_processor;
import random_pkg::*;

 logic clk;

 risc_processor risc_processor_dut (
  .clk(clk)
 );

  covergroup risc_processor_cg @(posedge clk);
    option.per_instance = 1;
    opcode : coverpoint risc_processor_dut.DU.im.instruction[15:12] {
      bins range[] = {[0:13]};									//opcode defined only from 0 to 13
    }
    dest_reg : coverpoint risc_processor_dut.DU.im.instruction[11:9] {
      bins range[] = {[0:7]};									//dest reg is only 3 bit wide
    }
  endgroup
  
  risc_processor_cg risc_processor_cg_inst;
  random_instruction rand_obj1;
  
  initial 
    begin
      clk <=0;
      risc_processor_cg_inst = new();
      `simulation_time;
      $display("Coverage for opcode = %0.2f %%", risc_processor_cg_inst.opcode.get_coverage());
      $display("Coverage for dest_reg = %0.2f %%", risc_processor_cg_inst.dest_reg.get_coverage());
      $display("Total Coverage = %0.2f %%", risc_processor_cg_inst.get_coverage());
      display_GPRs();
      display_data_memory();
      $finish;
    end
  
  initial
    begin
      `ifdef RANDOM_INSTRUCTION_INPUT
      
      rand_obj1 = new();
      for(int i=0; i<15; i++) begin												//as we have 15 instrcutions
        assert (rand_obj1.randomize());
        risc_processor_dut.DU.im.instruction_mem[i] = rand_obj1.instruct;
      end
      `endif
    end
        
 always 
  begin
   #5 clk = ~clk;
  end
  
  always_ff @(posedge clk) begin
    $display("time = %t opcode = %d instruction = %b", $time, risc_processor_dut.DU.im.instruction[15:12], risc_processor_dut.DU.im.instruction);
    $display("time = %t alu_input1 = %d alu_input2 = %d alu_output = %d", $time, risc_processor_dut.DU.alu_unit.src_1, risc_processor_dut.DU.alu_unit.src_2, risc_processor_dut.DU.alu_unit.result);
  end
  
  task display_GPRs();
    $display("GPRs values are below");
    for(int j=0; j < 8 ; j++)
      $display("Value of R%d is %d",j, risc_processor_dut.DU.reg_file.register_array[j]);
  endtask
  
  task display_data_memory();
    $display("Data Memory values are below");
    for(int j=0; j < 8 ; j++)
      $display("Value of R%d is %d",j, risc_processor_dut.DU.dm.memory[j]);
  endtask
  
endmodule
