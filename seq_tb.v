`timescale 1ns / 1ps
`include "seq_wrapper.v"

module tb_seq_wrapper;
    // Clock signal
    reg clk;

    // Instantiate the seq_wrapper module
    seq_wrapper uut (
        .clk(clk)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Pulse clock every 10ns
    end

    // Initial block to run the simulation
    initial begin
        // Run the simulation for a specific time
        #1000; // Run for 1000ns
        $stop; // Stop the simulation
    end
endmodule