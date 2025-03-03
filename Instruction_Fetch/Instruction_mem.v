// instruction memory

module insmem(
    input [7:0] address,
    output [6:0] ctrl,
    output [5:0] rs1,
    output [5:0] rs2,
    output [5:0] rd,
    output [31:0] instruction
);

    reg [7:0] memory [0:255];
    // instruction mem is in little endian format

    initial begin
        $readmemh("Instructions.mem", memory); 
    end
    // access the memory location indicated by the 8 bit address

    //  reg [7:0] address = 8'h0;

        reg [6:0] ctrl_reg;
        reg [5:0] rs1_reg;
        reg [5:0] rs2_reg;
        reg [5:0] rd_reg;
        reg [31:0] instruction_reg;


        // missed bits 12 to 14 for funct3
        // missed bits 25 to 31 for funct7  

    // initial begin
    //     #1
    //     $display("Address: %h", address);
    //     $display("Instruction: %h", instruction);
    //     $display("Opcode: %b", ctrl);
    //     $display("rd: %b", rd);
    //     $display("rs1: %b", rs1);
    //     $display("rs2: %b", rs2);
    // end
    
    always @(address) begin

        ctrl_reg = memory[address][6:0];
        rd_reg = {memory[address+1][3:0],memory[address][7]};
        rs1_reg = {memory[address+2][3:0], memory[address+1][7]}; //skipped 3 bits for funct3
        rs2_reg = {memory[address+3][0],memory[address+2][7:4]};
        instruction_reg = {memory[address+3],memory[address+2],memory[address+1],memory[address]};
        
        case (ctrl_reg)
            7'b0110011: begin // R-format 
                $display("\n --> insmem: R-format with opcode 0110011");
                $display("adding rs1=%d to rs2=%d into rd=%d", rs1,rs2, rd);
            end
            7'b0010011: begin // I-format (for immediate add)
                $display("\n --> insmem: I-format with opcode 0010011");
                $display("adding rs1=%d with imm=%d in rd=%d \t \t x%d = x%d + %d", rs1, $signed(instruction[31:20]), rd, rd, rs1, $signed(instruction[31:20]));
            end
            7'b0000011: begin // Load (ld)
                $display("\n --> insmem: Load with opcode 0000011");
                $display("loading from 'address in rs1'=%d with offset imm= %d in rd=%d", rs1, $signed(instruction[31:20]), rd);
            end
            7'b0100011: begin // Store (sd)
                $display("\n --> insmem: Store with opcode 0100011");
                $display("storing to 'address in rs1'=%d with offset imm= %d from rs2=%d", rs1, $signed({{52{instruction[31]}},instruction[31:25], instruction[11:7]}), rs2);
            end
            7'b1100011: begin // Branch (beq)
                $display("\n --> insmem: Branch with opcode 1100011");
                $display("branching if rs1=%d is equal to rs2=%d to PC = %d + 2*imm= %d", rs1, rs2,address,$signed({{52{instruction[31]}},instruction[31],instruction[7], instruction[30:25], instruction[11:8]}));
            end
            default: begin
                // Default case to handle undefined opcodes
                $display("\n --> insmem: Undefined opcode: %b", ctrl_reg);
            end
        endcase
    end

    assign ctrl = ctrl_reg;
    assign rd = rd_reg;
    assign rs1 = rs1_reg; //skipped 3 bits for funct3
    assign rs2 = rs2_reg;
    assign instruction = instruction_reg;


endmodule