`timescale 1ns / 1ps
`include "mem.v"
`include "wb_mux.v"

module MEM_WB (
    input clk,
    input [63:0] address, data_in, // Inputs to memory
    input MemWrite, MemRead, // Control signals for memory

    // MEM stage outputs
    input [63:0] rd_data, ALU_data, address_out1,

    // Control Inputs
    input MemtoReg, // WB control
    input regwrite, // WB control

    // Control Outputs
    output reg MemtoReg_out, // WB
    output reg regwrite_out, // WB

    // for forwarding unit
    input [4:0] EX_MEM_rd,
    
    // Data Outputs
    output reg [63:0] rd_data_out, // WB
    output reg [63:0] ALU_data_out, // WB
    output reg [63:0] address_out1_out, // WB

    // for forwarding unit
    output reg [4:0] MEM_WB_rd,

    // Final Writeback Output
    output [63:0] writeback
);

    // Memory Module Instantiation
    wire signed [63:0] mem_data_out;
    wire signed [63:0] mem_address_out;

    mem memory_block (
        .clk(clk),
        .address(address),
        .data_in(data_in),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .data_out(mem_data_out),
        .address_out(mem_address_out)
    );

    // MUX for Writeback
    wb_mux writeback_mux (
        .alu_out(ALU_data),
        .mem_out(mem_data_out),
        .MemtoReg(MemtoReg),
        .writeback(writeback)
    );

    always @(posedge clk) begin
        // Forward all inputs to outputs
        rd_data_out      <= rd_data;
        ALU_data_out     <= ALU_data;
        address_out1_out <= address_out1;
        MemtoReg_out     <= MemtoReg;
        regwrite_out     <= regwrite;
        MEM_WB_rd        <= EX_MEM_rd;
    end

endmodule
