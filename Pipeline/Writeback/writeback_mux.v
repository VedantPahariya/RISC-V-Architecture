module wb_mux(
    input [63:0] alu_out,
    input [63:0] mem_out,
    output [63:0] writeback,
    input MemtoReg
);

    reg [63:0] writeback_reg;

    // the writeback is updating at next clock pulse only

    always @(*)
    begin
        writeback_reg = MemtoReg ? mem_out : alu_out;
        //$display("Writeback updated to %d", writeback_reg);
        //some strange behaviour in writeback output
    end

    assign writeback = writeback_reg;

    //assign writeback_reg = MemtoReg ? mem_out : alu_out;

endmodule