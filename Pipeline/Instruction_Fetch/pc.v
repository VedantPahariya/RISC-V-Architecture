module program_counter(
    input clk,
    input signed [7:0] next_addr,
    output [7:0] curr_addr
);

    reg signed [7:0] PC;

    initial begin
        PC = 8'b11111100; //trying PC equals -4
        $display("PC updated to %d", PC);
    end

    always @(posedge clk) begin
        if(next_addr >= 0) 
            PC <= next_addr;
        else 
            PC = 0;
        $display("----------------------------------------------------------");
        $display("\n \nPC updated to %d", PC);
    end

    // always @(PC) begin
    //     $display("----------------------------------------------------------");
    //     $display("\n \nPC updated to %d", PC);
    // end

    assign curr_addr = PC;

endmodule