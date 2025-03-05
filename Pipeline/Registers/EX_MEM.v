module EX_MEM (
    input clk,  
    input rst, // Reset signal

    // Data Inputs
    input [63:0] ALU_data, rd_data, rs_2_in, // Data from registers
    input [63:0] imm_gen, // Immediate value
    input [31:0] pc_branch_in, // Program Counter for branch
    input zero, // Zero flag for branch decision

    // Control Inputs
    input MemtoReg, // WB
    input regwrite, // WB
    input branch, // MEM
    input MemRead, MemWrite, // MEM

    // Data Outputs
    output reg [31:0] pc_branch_out,
    output reg [63:0] ALU_data_out, rd_data_out, rs_2_out, imm_out,
    output reg zero_out, 

    // Control Outputs
    output reg MemtoReg, regwrite,
    output reg branch, MemRead, MemWrite
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset all outputs
        ALU_data_out  <= 0;
        rd_data_out   <= 0;
        rs_2_out      <= 0;
        imm_out       <= 0;
        pc_branch_out <= 0;
        zero_out      <= 0;

        MemtoReg      <= 0;
        regwrite      <= 0;
        branch        <= 0;
        MemRead       <= 0;
        MemWrite      <= 0;
    end 
    else begin
        // Forward all inputs to outputs
        ALU_data_out  <= ALU_data;
        rd_data_out   <= rd_data;
        rs_2_out      <= rs_2_in;
        imm_out       <= imm_gen;
        pc_branch_out <= pc_branch_in;
        zero_out      <= zero;

        MemtoReg      <= MemtoReg;
        regwrite      <= regwrite;
        branch        <= branch;
        MemRead       <= MemRead;
        MemWrite      <= MemWrite;
    end
end

endmodule
