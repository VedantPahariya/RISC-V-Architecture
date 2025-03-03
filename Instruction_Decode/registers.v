// registers

module register(
    input clk,
    input signed [63:0] wrt_data,
    input [5:0] rs1,
    input [5:0] rs2,
    input [5:0] rd,
    input RegWrite, //for the control for writing
    output [63:0] read_data_1,
    output [63:0] read_data_2
);

    reg signed[63:0] register [0:31];
    
    initial begin
        $readmemh("Registerlog.mem", register); 
    end

    reg [63:0] read_data_1_reg;
    reg [63:0] read_data_2_reg;

    always @ (rs1 or rs2) begin
        read_data_1_reg = register[rs1];
        read_data_2_reg = register[rs2];
    end

    //here only at negative edge of clk we write the data
    always @ (negedge clk) begin
        $display("RegWrite: %d", RegWrite);
        if(RegWrite)
        begin
            register[rd] = wrt_data;
            $display("\n --> Register %d updated to %d", rd, wrt_data);
            $writememh("Registerlog.mem", register);  // Save updated registers to file
        end
    end    

    assign read_data_1 = read_data_1_reg;
    assign read_data_2 = read_data_2_reg;

    // initial begin
    //     memory[0] = 64'b0;
    // end

endmodule