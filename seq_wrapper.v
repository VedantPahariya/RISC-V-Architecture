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

// Starting with PC block
wire [7:0] adder_pc;
wire [7:0] pc_im;

//Instruction Block
wire [6:0] ctrl;
wire [5:0] readr1;
wire [5:0] readr2;
wire [5:0] write_rd;
wire [31:0] instruction;

//Control Block
wire branch;
wire RegWrite;
wire MemtoReg;
wire MemRead;
wire MemWrite;
wire alu_src;

//ALU Control Block
wire [1:0] alu_op;
wire [3:0] aluc_out;

//Register Block
wire [63:0] writeback;
wire [63:0] regdata1;
wire [63:0] regdata2;

//Immediate Block
wire [63:0] immgen;

program_counter pc_inst(.next_addr(adder_pc), .curr_addr(pc_im));
insmem ins_inst(.address(pc_im), .ctrl(ctrl), .rs1(readr1), . rs2(readr2), .rd(write_rd), .instruction(instruction));
alucontrol aluc_inst(.instruction(instruction), .alu_op(alu_op), .alu_control(aluc_out));
control ctrl_inst(.ctrl(ctrl), .branch(branch), .RegWrite(RegWrite), .MemtoReg(MemtoReg), .MemRead(MemRead), .MemWrite(MemWrite), .alu_src(alu_src), .alu_op(alu_op));
register reg_inst(.clk(clk), .wrt_data(writeback), .rs1(readr1), .rs2(readr2), .rd(write_rd), .RegWrite(RegWrite), .read_data_1(read_data_1), .read_data_2(read_data_2));
imm_gen imm_inst(.instruction(instruction), .immgen());


endmodule