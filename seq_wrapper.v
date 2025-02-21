`include "alu.v"
`include "adder.v"
`include "alu_control.v"
`include "immgen.v"
`include "instruction_mem.v"
`include "control.v"
`include "mem.v"
`include "registers.v"
`include "pc.v"

module (
    input clk; // clock control signal for the entire processor
);
// The node naming convention will be <data from element>_<data to element>


wire [7:0] adder_pc;
wire [7:0] pc_im;
wire [6:0] ctrl;
wire [5:0] readr1;
wire [5:0] readr2;
wire [5:0] write_rd;
wire [31:0] instruction;
wire branch;
wire RegWrite;
wire MemtoReg;
wire MemRead;
wire MemWrite;
wire alu_src;
wire [1:0] alu_op;
wire [3:0] aluc_out;

program_counter pc_inst(.next_addr(adder_pc), .curr_addr(pc_im));
insmem ins_inst(.address(pc_im), .ctrl(ctrl), .rs1(readr1), . rs2(readr2), .rd(write_rd), .instruction(instruction));
alucontrol aluc_inst(.instruction(instruction), .alu_op(alu_op), .alu_control(aluc_out));




endmodule