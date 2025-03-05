module MEM_WB (
    input clk,
    input [63:0] rd_data, ALU_data, address_out1, // MEM stage outputs

    // Control Inputs
    input MemtoReg, // WB control
    input regwrite, // WB control

    // Control Outputs
    output reg MemtoReg_out, // WB
    output reg regwrite_out, // WB

    // Data Outputs
    output reg [63:0] rd_data_out, // WB
    output reg [63:0] ALU_data_out, // WB
    output reg [63:0] address_out1_out // WB
);

always @(posedge clk or posedge rst) begin
        // Forward all inputs to outputs
        rd_data_out      <= rd_data;
        ALU_data_out     <= ALU_data;
        address_out1_out <= address_out1;

        MemtoReg_out     <= MemtoReg;
        regwrite_out     <= regwrite;
end

endmodule

