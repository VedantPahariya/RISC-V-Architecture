//this block takes input from control block or ID/EX register for the control signals
//from the adder block we take pc_branch_in
//from ALU result we take alu data 
//from ID/EX we take rs2_in and rd_in

module EX_MEM (
    input clk,  
    // Data Inputs
    input [63:0] ALU_data, rd_data, rs_2_in, // Data from registers
    input [31:0] pc_branch_in, // Program Counter for branch
    input zero, // Zero flag for branch decision

    //for fwd unit
    input [4:0] Rd,


    // Control Inputs
    input MemtoReg, // WB
    input regwrite, // WB
    input branch, // MEM
    input MemRead, MemWrite, // MEM

    // Data Outputs
    output reg [31:0] pc_branch_out,
    output reg [63:0] ALU_data_out,rd_data_out, rs_2_out,
    output reg zero_out, 

    // Control Outputs
    output reg MemtoReg_out, regwrite_out,
    output reg branch_out, MemRead_out, MemWrite_out,

    //for fwd unit this output also goes to fwd unit and to MEM/WB register
    output reg [4:0] EX_MEM_rd 
);

always @(posedge clk) begin
        // Forward all inputs to outputs
        ALU_data_out  <= ALU_data;
        rd_data_out   <= rd_data;
        rs_2_out      <= rs_2_in;
        pc_branch_out <= pc_branch_in;
        zero_out      <= zero;
        MemtoReg_out  <= MemtoReg;
        regwrite_out  <= regwrite;
        branch_out    <= branch;
        MemRead_out   <= MemRead;
        MemWrite_out  <= MemWrite;
        EX_MEM_rd     <= Rd;
        
    end

endmodule
