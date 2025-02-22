module program_counter(
    input clk,
    input [7:0] next_addr,
    output [7:0] curr_addr
);

    reg [7:0] PC;

    initial begin
        PC = 8'b0;
    end

    always @(posedge clk) begin
        PC <= next_addr;
    end

    assign curr_addr = PC;

endmodule