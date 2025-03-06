// Memory Block of ALU
module mem(
    input [63:0] address,
    input signed [63:0] data_in,
    input MemWrite,
    input MemRead,
    output signed [63:0] data_out,
    output reg signed [63:0] address_out // Just for showing in GTKWave
);
    
    reg signed [63:0] memory [0:1023];
    reg signed[63:0] data_out_reg;
    reg mem_reg;

    initial begin
        $readmemh("Memorylog.mem", memory); 
    end
    
    always@(data_in or MemWrite or address) begin
        if(MemWrite) begin
            memory[address] = data_in;
            address_out = memory[address];
            $display("\n --> Memory %d updated to %d", address, data_in);
            $writememh("Memorylog.mem", memory);  // Save updated registers to file
        end
    end

    always @ (*) begin
        if(MemRead) begin
        data_out_reg <= memory[address];
    end
    end

    assign data_out = data_out_reg;

    // always @ (posedge clk) begin
    //     mem_reg = MemWrite;
    //     //$display("\n --> Memwrite %d read",mem_reg);
    //     if(mem_reg) begin
    //     memory[address] = data_in;
    //     address_out = memory[address];
    //     $display("\n --> Memory %d updated to %d", address, data_in);
    //     $writememh("Memorylog.mem", memory);  // Save updated registers to file
    // end
    // end

    // always @ (address) begin
    //     address_out = memory[address]; // To display memory storing value in GTKWave
    // end
endmodule

