module ID_EX (
    input clk,
    input [63:0] rs1_data, rs2_data, rd_data, // Data from registers
    input [63:0] imm_gen, // Immediate value
    input [7:0] pc_in, // Program Counter
    input MemtoReg, // Write-back control
    input regwrite, // Write-back control
    input branch, // Memory control
    input MemRead, MemWrite, // Memory control
    input alu_src, // Execution control
    input [1:0] alu_op, // ALU operation control
    input [31:0] instruction, // ALU control signal
    //sending these both to forwarding unit
    input [4:0] IF_ID_rs1,
    input [4:0] IF_ID_rs2,
    input [4:0] IF_ID_rd,

    output reg [7:0] pc_out,
    output reg [63:0] rs1_data_out, rs2_data_out, rd_data_out, imm_out,
    output reg MemtoReg_out, regwrite_out,
    output reg branch_out, MemRead_out, MemWrite_out,
    output reg alu_src_out,
    output reg [1:0] alu_op_out,
    output reg [31:0] instruction_out,
    //sending to forwarding unit
    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output reg [4:0] rd
);

// Non-blocking assignments are used to update all outputs on the positive edge of the clock
always @(posedge clk) begin
    rs1_data_out <= rs1_data;
    rs2_data_out <= rs2_data;
    rd_data_out  <= rd_data;
    imm_out      <= imm_gen;
    pc_out       <= pc_in;
    MemtoReg_out <= MemtoReg;
    regwrite_out <= regwrite;
    branch_out   <= branch;
    MemRead_out  <= MemRead;
    MemWrite_out <= MemWrite;
    alu_src_out  <= alu_src;
    alu_op_out   <= alu_op;
    instruction_out <= instruction;
    rs1 <= IF_ID_rs1;
    rs2 <= IF_ID_rs2;
    rd  <= IF_ID_rd;
end

endmodule