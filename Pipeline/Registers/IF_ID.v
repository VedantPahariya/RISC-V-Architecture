// Memory Block of ALU
module IF_ID(
    input clk,
    input [31:0] instruction_in,
    input [31:0] pc_in,
    output [31:0] instruction_out,
    output [31:0] pc_out
);

    reg [31:0] instruction_out;
    reg [31:0] pc_out;

    always @(posedge clk) begin
        instruction_out <= instruction_in;
        pc_out <= pc_in;
    end

    


endmodule

