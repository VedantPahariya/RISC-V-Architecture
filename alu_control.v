module alucontrol(
    input [31:0] instruction,
    input [1:0] alu_op,
    output reg [3:0] alu_control
);

    wire [6:0] funct7;
    wire [2:0] funct3;
    
    assign funct7 = instruction[31:25];
    assign funct3 = instruction[14:12];

    always @(*) begin
        case (alu_op)
            2'b00: alu_control = 4'b0010; // ADD (for lw/sw)
            2'b01: alu_control = 4'b0110; // SUB (for beq)
            2'b10: begin
                case (funct3)
                    3'b000: alu_control = (funct7[5] == 1'b1) ? 4'b0110 : 4'b0010; // SUB if funct7[5] = 1, else ADD
                    3'b100: alu_control = 4'b0011; // XOR
                    3'b110: alu_control = 4'b0001; // OR
                    3'b111: alu_control = 4'b0000; // AND
                    3'b001: alu_control = 4'b0100; // SLL
                    3'b101: alu_control = (funct7[5] == 1'b1) ? 4'b0111 : 4'b0101; // SRA if funct7[5] = 1, else SRL
                    3'b010: alu_control = 4'b1000; // SLT
                    3'b011: alu_control = 4'b1001; // SLTU
                    default: alu_control = 4'b0000; // Default to AND (safe fallback)
                endcase
            end
            default: alu_control = 4'b0000; // Default
        endcase
    end
endmodule
