`include "adder.v"
`timescale 1ns/1ps

module test_adder;
    // Inputs as reg
    reg [7:0] address;
    reg [63:0] immgen;
    reg branch;
    reg zero_flag;
    
    // Outputs as wire
    wire [7:0] address_out;
    
    // Instantiate the Device Under Test (DUT)
    adder dut (
        .address(address),
        .immgen(immgen),
        .branch(branch),
        .zero_flag(zero_flag),
        .address_out(address_out)
    );
    
    initial begin
        // Initialize inputs
        address = 8'h00;
        immgen = 64'h0000_0000_0000_0000;
        branch = 0;
        zero_flag = 0;
        
        // Add waves to dump file
        $dumpfile("adder_tb.vcd");
        $dumpvars(0, test_adder);
        
        // Test 1: PC+4 (No branch)
        #10;
        address = 8'h20;
        immgen = 64'h0000_0000_0000_0004;
        branch = 0;
        zero_flag = 1;
        #10;
        if(address_out !== 8'h24)
            $display("Test 1 Failed: Expected 0x24, Got %h", address_out);
            
        // Test 2: Branch taken
        #10;
        address = 8'h20;
        immgen = 64'h0000_0000_0000_0004;
        branch = 1;
        zero_flag = 1;
        #10;
        if(address_out !== 8'h28)
            $display("Test 2 Failed: Expected 0x28, Got %h", address_out);
            
        // Test 3: Branch not taken
        #10;
        address = 8'h20;
        immgen = 64'h0000_0000_0000_0004;
        branch = 1;
        zero_flag = 0;
        #10;
        if(address_out !== 8'h24)
            $display("Test 3 Failed: Expected 0x24, Got %h", address_out);
            
        #10;
        $finish;
    end
endmodule