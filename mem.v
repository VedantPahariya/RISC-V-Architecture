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

    always @ (posedge clk)
    begin if(MemWrite)
    begin
        memory[address] <= data_in;
    end
    end


    always @ (posedge clk)
    begin if(MemRead)
    begin
        data_out <= memory[address];
    end
    end

endmodule

