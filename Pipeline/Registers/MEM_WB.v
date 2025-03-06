//this will go to wb_mux

module MEM_WB (
    input clk,

    // MEM stage outputs
    input [63:0] ALU_data,read_Data, // Data to be written to register

    // Control Inputs
    input MemtoReg, // WB control
    input regwrite, // WB control

    // Control Outputs
    output reg MemtoReg_out, // WB
    output reg regwrite_out, // WB

    // for forwarding unit
    input [4:0] EX_MEM_rd,
    
    // Data Outputs\
    output reg [63:0] ALU_data_out, // WB
    output reg [63:0] read_Data_out, // WB

    // for forwarding unit
    output reg [4:0] MEM_WB_rd//output of EX_MEM_rd

);

    always @(posedge clk) begin
        // Forward all inputs to outputs
        read_Data_out      <= read_Data;
        ALU_data_out     <= ALU_data;
        MemtoReg_out     <= MemtoReg;
        regwrite_out     <= regwrite;
        MEM_WB_rd        <= EX_MEM_rd;
    end

endmodule


