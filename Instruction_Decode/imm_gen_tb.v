`timescale 1ns / 1ps
`include "immgen.v"

module imm_gen_tb;
    reg [31:0] instruction;
    wire [63:0] imm;
    
    // Instantiate the imm_gen module
    imm_gen uut (
        .instruction(instruction),
        .imm(imm)
    );
    
    initial begin
        // Monitor output
        $monitor("Time = %0t | instruction = %b | imm = %b", $time, instruction, imm);
        
        // Test cases
        instruction = 32'b00000000000000000000000000000000; #10;
        instruction = 32'b11111111111111111111111111111111; #10;
        instruction = 32'b00000000000000000000111111111111; #10;
        instruction = 32'b10000000000000000000000000000000; #10;
        instruction = 32'b01111111111111110000000000000000; #10;
        instruction = 32'b10101010101010101010101010101010; #10;
        instruction = 32'b11001100110011001100110011001100; #10;
        
        // End simulation
        $finish;
    end
endmodule
