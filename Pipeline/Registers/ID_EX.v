module ID_EX (
    input clk,
    input PCsrc,
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

always @(posedge clk) begin
    if (!PCsrc) begin
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
    else begin
        rs1_data_out <= 64'b0;
        rs2_data_out <= 64'b0;
        rd_data_out  <= 64'b0;
        imm_out      <= 64'b0;
        pc_out       <= 8'b0;
        MemtoReg_out <= 1'b0;
        regwrite_out <= 1'b0;
        branch_out   <= 1'b0;
        MemRead_out  <= 1'b0;
        MemWrite_out <= 1'b0;
        alu_src_out  <= 1'b0;
        alu_op_out   <= 2'b0;
        instruction_out <= 32'b0;
        rs1 <= 5'b0;
        rs2 <= 5'b0;
        rd  <= 5'b0;
    end
end

always @(posedge clk) begin
    #3;
    // $display("ID_EX: rs1_data_out = %d, rs2_data_out = %d, rd_data_out = %d, imm_out = %d, pc_out = %d, MemtoReg_out = %d, regwrite_out = %d, branch_out = %d, MemRead_out = %d, MemWrite_out = %d, alu_src_out = %d, alu_op_out = %d, instruction_out = %d, rs1 = %d, rs2 = %d, rd = %d", rs1_data_out, rs2_data_out, rd_data_out, imm_out, pc_out, MemtoReg_out, regwrite_out, branch_out, MemRead_out, MemWrite_out, alu_src_out, alu_op_out, instruction_out, rs1, rs2, rd);
    $display("ID_EX: rs1 = %d, rs2 = %d, rd = %d", rs1, rs2, rd);
end

endmodule