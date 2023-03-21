`include "parameters.sv"
`timescale 1ns / 1ps

class random_instruction;
  rand logic [3:0] opcode;
  rand logic [2:0] src1;
  rand logic [2:0] src2;
  rand logic [2:0] dest1;
  rand logic [5:0] offset;
  
  constraint opcode_c { opcode inside {[0:13]}; }
  constraint offset_c { offset inside {[0:1]};  }
  
endclass

module top_risc_processor;

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
      $finish;
    end
  
  initial
    begin
      `ifdef RANDOM_INSTRUCTION_INPUT
      
      rand_obj1 = new();
      for(int i=0; i<15; i++) begin												//as we have 15 instrcutions
        assert (rand_obj1.randomize());
        if(rand_obj1.opcode inside {[2:10]})										//for alu operations
          risc_processor_dut.DU.im.inst_mem[i] = {rand_obj1.opcode,rand_obj1.dest1,rand_obj1.src1,rand_obj1.src2,rand_obj1.offset[2:0]};
        else if(rand_obj1.opcode inside {0, 1, 11, 12})							//for mem and branch operation
          risc_processor_dut.DU.im.inst_mem[i] = {rand_obj1.opcode,rand_obj1.dest1,rand_obj1.src1,rand_obj1.offset};
        else if(rand_obj1.opcode == 13)											//for jump
          risc_processor_dut.DU.im.inst_mem[i] = {rand_obj1.opcode,6'b000000,rand_obj1.offset};
        $display("time=%t, i=%d, random opcode=%d, dest1=%d, src1=%b, src2=%b, offset=%b instruction=%b", $time, i, rand_obj1.opcode, rand_obj1.dest1, rand_obj1.src1, rand_obj1.src2, rand_obj1.offset, risc_processor_dut.DU.im.inst_mem[i]);
      end
      `endif
    end
        
 always 
  begin
   #5 clk = ~clk;
  end
  
  always @(posedge clk) begin
    $display("time = %t opcode = %d instruction = %b", $time, risc_processor_dut.DU.im.instruction[15:12], risc_processor_dut.DU.im.instruction);
    $display("time = %t alu_input1 = %d alu_input2 = %d alu_output = %d", $time, risc_processor_dut.DU.alu_unit.a, risc_processor_dut.DU.alu_unit.b, risc_processor_dut.DU.alu_unit.result);
  end
  
endmodule




  
  
