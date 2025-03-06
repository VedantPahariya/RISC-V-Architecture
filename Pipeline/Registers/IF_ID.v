// Memory Block of ALU
module IF_ID(
    input clk,
    input [31:0] instruction_in,
    input [7:0] pc_in,
    output [6:0] ctrl,
    output [4:0] rs1,
    output [4:0] rs2,
    output [4:0] rd,
    output reg [31:0] instruction_out,
    output reg [7:0] pc_out
);

    always @(posedge clk) begin
        instruction_out <= instruction_in;
        pc_out <= pc_in;

        ctrl_reg <= instruction_in[6:0];    // opcode
        rd_reg <= instruction_in[11:7];     // rd field
        rs1_reg <= instruction_in[19:15];   // rs1 field
        rs2_reg <= instruction_in[24:20];   // rs2 field
    end


    // Bit Slicing of Instruction 
    reg [6:0] ctrl_reg;
    reg [4:0] rs1_reg;
    reg [4:0] rs2_reg;
    reg [4:0] rd_reg;
    reg [31:0] instruction_reg;
    // missed bits 12 to 14 for funct3
    // missed bits 25 to 31 for funct7 
    
    // always @(posedge clk) begin
    //     ctrl_reg <= instruction_out[6:0];    // opcode
    //     rd_reg <= instruction_out[11:7];     // rd field
    //     rs1_reg <= instruction_out[19:15];   // rs1 field
    //     rs2_reg <= instruction_out[24:20];   // rs2 field
    // end

    always @(instruction_out) begin 
        case (ctrl_reg)
            7'b0110011: begin // R-format 
                $display("\n --> Ins Fetch: R-format with opcode 0110011");
                //$display("adding rs1=%d to rs2=%d into rd=%d", rs1,rs2, rd);
            end
            7'b0010011: begin // I-format (for immediate add)
                $display("\n --> Ins Fetch: I-format with opcode 0010011");
                $display("adding rs1=%d with imm=%d in rd=%d \t \t x%d = x%d + %d", rs1, $signed(instruction_out[31:20]), rd, rd, rs1, $signed(instruction_out[31:20]));
            end
            7'b0000011: begin // Load (ld)
                $display("\n --> Ins Fetch: Load with opcode 0000011");
                $display("loading from 'address in rs1'=%d with offset imm= %d in rd=%d", rs1, $signed(instruction_out[31:20]), rd);
            end
            7'b0100011: begin // Store (sd)
                $display("\n --> Ins Fetch: Store with opcode 0100011");
                $display("storing to 'address in rs1'=%d with offset imm= %d from rs2=%d", rs1, $signed({{52{instruction_out[31]}},instruction_out[31:25], instruction_out[11:7]}), rs2);
            end
            7'b1100011: begin // Branch (beq)
                $display("\n --> Ins Fetch: Branch with opcode 1100011");
                $display("branching if rs1=%d is equal to rs2=%d to PC = %d + 2*imm= %d", rs1, rs2,pc_out,$signed({{52{instruction_out[31]}},instruction_out[31],instruction_out[7], instruction_out[30:25], instruction_out[11:8]}));
            end
            default: begin
                // Default case to handle undefined opcodes
                $display("\n --> Ins Fetch: Undefined opcode: %b", ctrl_reg);
            end
        endcase
    end

    assign ctrl = ctrl_reg;
    assign rd = rd_reg;
    assign rs1 = rs1_reg; //skipped 3 bits for funct3
    assign rs2 = rs2_reg;

    //  reg [7:0] pc_in = 8'h0;

    // initial begin
    //     #1
    //     $display("Address: %h", pc_in);
    //     $display("Instruction: %h", instruction);
    //     $display("Opcode: %b", ctrl);
    //     $display("rd: %b", rd);
    //     $display("rs1: %b", rs1);
    //     $display("rs2: %b", rs2);
    // end

endmodule