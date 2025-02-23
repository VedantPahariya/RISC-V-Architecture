`timescale 1ns / 1ps
`include "seq_wrapper.v"

module tb_seq_wrapper;
    // Clock signal
    reg clk;

    // Instantiate the seq_wrapper module
    seq_wrapper uut (
        .clk(clk)
    );


    // Initial block to run the simulation
    initial begin
        // Run the simulation for a specific time
        clk = 0;
        #100; // Run for 1000ns
        $stop; // Stop the simulation
        
    end

    always #10 clk = ~clk;

    always @(posedge clk) begin
        $strobe("clock high");
    end

endmodule

