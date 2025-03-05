module ID_EX (
    input clk,  
    input rst, // Reset signal
    input [63:0] rs1_data, rs2_data, rd_data, // Data from registers
    input [63:0] imm_gen, // Immediate value
    input [31:0] pc_in, // Program Counter
    input MemtoReg, // Write-back control
    input regwrite, // Write-back control
    input branch, // Memory control
    input MemRead, MemWrite, // Memory control
    input alu_src, // Execution control
    input [1:0] alu_op, // ALU operation control
    input [31:0] instruction, // ALU control signal

    output reg [31:0] pc_out,
    output reg [63:0] rs1_data_out, rs2_data_out, rd_data_out, imm_out,
    output reg MemtoReg, regwrite,
    output reg branch, MemRead, MemWrite,
    output reg alu_src,
    output reg [1:0] alu_op,
    output reg [31:0] instruction_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        rs1_data_out <= 0;
        rs2_data_out <= 0;
        rd_data_out  <= 0;
        imm_out      <= 0;
        pc_out       <= 0;
        MemtoReg     <= 0;
        regwrite     <= 0;
        branch       <= 0;
        MemRead      <= 0;
        MemWrite     <= 0;
        alu_src      <= 0;
        alu_op       <= 0;
        instruction_out <= 0;
    end 
    else begin
        rs1_data_out <= rs1_data;
        rs2_data_out <= rs2_data;
        rd_data_out  <= rd_data;
        imm_out      <= imm_gen;
        pc_out       <= pc_in;
        MemtoReg     <= MemtoReg;
        regwrite     <= regwrite;
        branch       <= branch;
        MemRead      <= MemRead;
        MemWrite     <= MemWrite;
        alu_src      <= alu_src;
        alu_op       <= alu_op;
        instruction_out <= instruction;
    end
end

endmodule
