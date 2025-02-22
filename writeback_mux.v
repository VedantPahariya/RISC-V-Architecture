module wb_mux(
    input [63:0] alu_out,
    input [63:0] mem_out,
    output [63:0] writeback,
    input MemtoReg
);

    assign writeback = MemtoReg ? mem_out : alu_out;

    always @(writeback)
    begin
        $display("\n Wrtback_mux: MemtoReg:%d mem_out:%d alu_out:%d Writeback:%d",MemtoReg, mem_out, alu_out, writeback);
    end
endmodule