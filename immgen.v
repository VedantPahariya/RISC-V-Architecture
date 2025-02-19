module imm_gen(
    input [31:0] instruction,
    output [63:0] imm
);

    //we want to  concatenate the msb of instruction till it becoms 64 bit and front
    assign imm = {52{instruction[31]},instruction[31],instruction[7], instruction[30:25], instruction[11:8]};

endmodule