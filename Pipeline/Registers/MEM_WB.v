module MEM_WB (
    input clk,
    input [63:0] rd_data, ALU_data, address_out1, // MEM stage outputs

    // Control Inputs
    input MemtoReg, // WB control
    input regwrite, // WB control

    // Control Outputs
    output reg MemtoReg_out, // WB
    output reg regwrite_out, // WB

 // for fwd unit
    input [4:0] EX_MEM_rd,


    // Data Outputs
    output reg [63:0] rd_data_out, // WB
    output reg [63:0] ALU_data_out, // WB
    output reg [63:0] address_out1_out // WB

    //for fwd unit
    output reg [4:0] MEM_WB_rd
);

always @(posedge clk or posedge rst) begin
        // Forward all inputs to outputs
        rd_data_out      <= rd_data;
        ALU_data_out     <= ALU_data;
        address_out1_out <= address_out1;
        MemtoReg_out     <= MemtoReg;
        regwrite_out     <= regwrite;
        MEM_WB_rd        <= EX_MEM_rd;
end

endmodule

