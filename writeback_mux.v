module wb_mux(
    input [63:0] alu_out,
    input [63:0] mem_out,
    output [63:0] writeback,
    input MemtoReg
);

    assign writeback = MemtoReg ? mem_out : alu_out;

endmodule