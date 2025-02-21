// Memory Block of ALU
module mem(
    input clk,
    input [63:0] address,
    input [63:0] data_in,
    input MemWrite,
    input MemRead,
    output [63:0] data_out
);
    
    reg [63:0] memory [0:1023];
    reg [63:0] data_out_reg;

    always @ (posedge clk) begin
    begin if(MemWrite)
        memory[address] <= data_in;
    end
    begin if(MemRead)
        data_out_reg <= memory[address];
    end
    end

    assign data_out = data_out_reg;

endmodule

