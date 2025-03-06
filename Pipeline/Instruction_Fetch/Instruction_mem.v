// instruction memory

module insmem(
    input [7:0] curr_addr,
    output [31:0] instruction
);

    reg [7:0] memory [0:255];
    // instruction mem is in little endian format

    initial begin
        $readmemh("./Instructions.mem", memory); 
    end

    // access the memory location indicated by the 8 bit address
    assign instruction = {memory[curr_addr+3],memory[curr_addr+2],memory[curr_addr+1],memory[curr_addr]};

endmodule