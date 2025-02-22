module imm_gen(
    input [31:0] instruction,
    output [63:0] imm
);

    wire opcode;
    reg [63:0] immediate;
    assign opcode = instruction[6:0];
    always @(*) begin
        
        case (opcode)
            7'b0010011: begin // I-format (for immediate add)
                immediate = {{52{instruction[31]}},instruction[31:20]};
            end
            7'b0000011: begin // Load (ld)
                immediate = {{52{instruction[31]}},instruction[31:20]};
            end
            7'b0100011: begin // Store (sd)
                immediate = {{52{instruction[31]}},instruction[31:25], instruction[11:7]};
            end
            7'b1100011: begin // Branch (beq)
                immediate = {{52{instruction[31]}},instruction[31],instruction[7], instruction[30:25], instruction[11:8]};
            end
            default: begin
                // Default case to handle undefined opcodes
                immediate = 64'b0;
            end
        endcase
    end

    assign imm = immediate;

endmodule