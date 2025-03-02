`include "Instruction_mem.v"
`timescale 1ns/1ps

module insmem_tb();
    // Inputs
    reg [7:0] address;
    
    // Outputs
    wire [6:0] ctrl;
    wire [5:0] rs1;
    wire [5:0] rs2;
    wire [5:0] rd;
    wire [31:0] instruction;

    // Instantiate the Device Under Test (DUT)
    insmem dut (
        .address(address),
        .ctrl(ctrl),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .instruction(instruction)
    );

    // Test stimulus
    initial begin
        // Add wave forms to view in simulator
        $dumpfile("insmem_tb.vcd");
        $dumpvars(0, insmem_tb);

        // Test case 1: Read from address 0
        address = 8'h00;
        #10; // Wait 10 time units
        $display("Test Case 1:");
        $display("Address: %h", address);
        $display("Instruction: %h", instruction);
        $display("Control: %b", ctrl);
        $display("rd: %b", rd);
        $display("rs1: %b", rs1);
        $display("rs2: %b", rs2);

        // Test case 2: Read from address 4
        address = 8'h04;
        #10;
        $display("\nTest Case 2:");
        $display("Address: %h", address);
        $display("Instruction: %h", instruction);
        $display("Control: %b", ctrl);
        $display("rd: %b", rd);
        $display("rs1: %b", rs1);
        $display("rs2: %b", rs2);

        // Test case 3: Read from address 8
        address = 8'h08;
        #10;
        $display("\nTest Case 3:");
        $display("Address: %h", address);
        $display("Instruction: %h", instruction);
        $display("Control: %b", ctrl);
        $display("rd: %b", rd);
        $display("rs1: %b", rs1);
        $display("rs2: %b", rs2);

        // End simulation
        #10;
        $finish;
    end

endmodule