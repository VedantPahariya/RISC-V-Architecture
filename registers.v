// registers

module register(
    input clk,
    input [63:0] wrt_data,
    input [5:0] rs1,
    input [5:0] rs2,
    input [5:0] rd,
    input RegWrite, //for the controll for writting
    output [63:0] read_data_1,
    output [63:0] read_data_2
);

    reg [63:0] memory [0:31];
    

    
     assign read_data_1 = memory[rs1];
     assign read_data_2 = memory[rs2];



    //here only at next clk we wrrite the data
    always @ (posedge clk) begin
        if(RegWrite)
        begin
            memory[rd] = wrt_data;
        end
    end    

    initial begin
        memory[0] = 64'b0;
    end



endmodule