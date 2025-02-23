module imm_gen(
    input [31:0] instruction,
    output [63:0] imm
);

    reg [6:0] opcode;
    reg [63:0] immediate;

    reg [100:0] command;
    always @(*) begin

        opcode = instruction[6:0];

        case (opcode)
            7'b0010011: begin // I-format (for immediate add)
                immediate = {{52{instruction[31]}},instruction[31:20]};
                command = "I-format";
            end
            7'b0000011: begin // Load (ld)
                immediate = {{52{instruction[31]}},instruction[31:20]};
                command = "Load";
            end
            7'b0100011: begin // Store (sd)
                immediate = {{52{instruction[31]}},instruction[31:25], instruction[11:7]};
                command = "Store";
            end
            7'b1100011: begin // Branch (beq)
                immediate = {{52{instruction[31]}},instruction[31],instruction[7], instruction[30:25], instruction[11:8]};
                command = "Branch";
            end
            default: begin
                // Default case to handle undefined opcodes
                immediate = 64'b0;
            end
        endcase

    $display("\n --> immgen: %s Immediate:%d",command, immediate);

    end

    assign imm = immediate;

endmodule