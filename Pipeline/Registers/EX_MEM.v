//this block takes input from control block or ID/EX register for the control signals
//from the adder block we take pc_branch_in
//from ALU result we take alu data 
//from ID/EX we take rs2_in and rd_in

module EX_MEM (
    input clk,  
    input PCsrc,
    // Data Inputs
    input [63:0] ALU_data, rd_data, // Data from registers
    // input rs_2_in, 
    input [7:0] branch_target, // Program Counter for branch
    input zero, // Zero flag for branch decision

    //for fwd unit
    input [4:0] Rd,

    // Control Inputs
    input MemtoReg, // WB
    input regwrite, // WB
    input branch, // MEM
    input MemRead, MemWrite, // MEM

    // Data Outputs
    output reg [7:0] branch_target_out,
    output reg [63:0] ALU_data_out,rd_data_out,
    output reg zero_out, 

    // Control Outputs
    output reg MemtoReg_out, regwrite_out,
    output reg branch_out, MemRead_out, MemWrite_out,

    //for fwd unit this output also goes to fwd unit and to MEM/WB register
    output reg [4:0] EX_MEM_rd 
);
always @(posedge clk) begin
    if (!PCsrc) begin
        ALU_data_out  <= ALU_data;
        rd_data_out   <= rd_data;
        branch_target_out <= branch_target;
        zero_out      <= zero;
        MemtoReg_out  <= MemtoReg;
        regwrite_out  <= regwrite;
        branch_out    <= branch;
        MemRead_out   <= MemRead;
        MemWrite_out  <= MemWrite;
        EX_MEM_rd     <= Rd;
    end
    else if (PCsrc==1) begin
        ALU_data_out  <= 64'b0;
        rd_data_out   <= 64'b0;
        branch_target_out <= 8'b0;
        zero_out      <= 1'b0;
        MemtoReg_out  <= 1'b0;
        regwrite_out  <= 1'b0;
        branch_out    <= 1'b0;
        MemRead_out   <= 1'b0;
        MemWrite_out  <= 1'b0;
        EX_MEM_rd     <= 5'b0;
    end
    else begin
        zero_out      <= 1'b0;
        MemtoReg_out  <= 1'b0;
        regwrite_out  <= 1'b0;
        branch_out    <= 1'b0;
        MemRead_out   <= 1'b0;
        MemWrite_out  <= 1'b0;
    end
end

    always@(posedge clk) begin
        #3;
        // $display("EX_MEM: ALU_data_out = %d, rd_data_out = %d, branch_target_out = %d, zero_out = %d, MemtoReg_out = %d, regwrite_out = %d, branch_out = %d, MemRead_out = %d, MemWrite_out = %d, EX_MEM_rd = %d", ALU_data_out, rd_data_out, branch_target_out, zero_out, MemtoReg_out, regwrite_out, branch_out, MemRead_out, MemWrite_out, EX_MEM_rd);
        $display("EX_MEM: EX_MEM_rd = %d", EX_MEM_rd);
    end

endmodule
