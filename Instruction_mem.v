// instruction memory

module insmem(
    input [7:0] address,
    //output [31:0] data_out
    output [6:0] ctrl,
    output [5:0] rs1,
    output [5:0] rs2,
    output [5:0] rd,
    output [31:0] instruction
);

    reg [7:0] memory [0:255];
    // instruction mem is in little endian format

    // access the memory location indicated by the 8 bit address

    // reg [7:0] addres = 8'b00010101;

       assign ctrl = memory[address][6:0];
       assign rd = {memory[address+1][3:0],memory[address][7]};
       assign rs1 = {memory[address+2][3:0], memory[address+1][7]}; //skipped 3 bits for funct3
       assign rs2 = {memory[address+3][0],memory[address+2][7:4]};
       assign instruction = {memory[address+3],memory[address+2],memory[address+1],memory[address]};

        // missed bits 12 to 14 for funct3
        // missed bits 25 to 31 for funct7  

    // initial begin
    //     //print the 0th index of addres
    //     $display("%d",addres[7]);
    //     $display("%b",addres[7:0]);
    //     // lmao
    // end



endmodule