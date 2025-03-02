`timescale 1ns/1ps
`include "registers.v"

module register_tb();
    // Inputs
    reg clk;
    reg [63:0] wrt_data;
    reg [5:0] rs1, rs2, rd;
    reg RegWrite;

    // Outputs
    wire [63:0] read_data_1, read_data_2;

    // Instantiate the register module
    register dut(
        .clk(clk),
        .wrt_data(wrt_data),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .RegWrite(RegWrite),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        // Add waveforms to view in simulator
        $dumpfile("register_tb.vcd");
        $dumpvars(0, register_tb);

        // Initialize inputs
        RegWrite = 0;
        wrt_data = 64'h0;
        rs1 = 6'd0;
        rs2 = 6'd0;
        rd = 6'd0;

        // Test Case 1: Write to register 5
        #10;
        RegWrite = 1;
        rd = 6'd5;
        wrt_data = 64'hAAAA_BBBB_CCCC_DDDD;
        #10;

        // Test Case 2: Read from register 5
        RegWrite = 0;
        rs1 = 6'd5;
        #10;
        $display("Test Case 2 - Read from reg[5]: %h", read_data_1);

        // Test Case 3: Write to register 10
        RegWrite = 1;
        rd = 6'd10;
        wrt_data = 64'h123456789ABCDEF0;
        #10;

        // Test Case 4: Read from both registers
        RegWrite = 0;
        rs1 = 6'd5;
        rs2 = 6'd10;
        #10;
        $display("Test Case 4 - Read from reg[5]: %h", read_data_1);
        $display("Test Case 4 - Read from reg[10]: %h", read_data_2);

        // Test Case 5: Write to register 0 (should remain 0)
        RegWrite = 1;
        rd = 6'd0;
        wrt_data = 64'hFFFFFFFFFFFFFFFF;
        #10;
        rs1 = 6'd0;
        RegWrite = 0;
        #10;
        $display("Test Case 5 - Read from reg[0]: %h", read_data_1);

        #10 $finish;
    end
endmodule