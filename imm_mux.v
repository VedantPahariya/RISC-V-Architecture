module(
    input [63:0] rs2;
    input [63:0] imm;
    output [63:0] res;
    input alu_src;
);

    assign res = alu_src ? imm : rs2;

endmodule