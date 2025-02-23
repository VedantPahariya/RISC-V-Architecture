module program_counter(
    input clk,
    input [7:0] next_addr,
    output [7:0] curr_addr
);

    reg [7:0] PC;

    initial begin
        PC = 8'b0;
        $display("PC updated to %d", PC);
    end

    assign curr_addr = PC;

    always @(posedge clk) begin
        PC <= next_addr;
        $display("----------------------------------------------------------");
        $display("\n \nPC updated to %d", next_addr);
    end

endmodule