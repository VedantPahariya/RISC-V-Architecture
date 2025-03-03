module control(
    input [6:0] ctrl, // Opcode
    output branch,
    output RegWrite,
    output MemtoReg,
    output MemRead,
    output MemWrite,
    output alu_src,
    output [1:0] alu_op
);

    // Temporary registers for control signals
    reg branch_reg, RegWrite_reg, MemtoReg_reg, MemRead_reg, MemWrite_reg, alu_src_reg;
    reg [1:0] alu_op_reg;

    always @(ctrl) begin
        // Default values
        branch_reg = 0;
        RegWrite_reg = 0;
        MemtoReg_reg = 0;
        MemRead_reg = 0;
        MemWrite_reg = 0;
        alu_src_reg = 0;
        alu_op_reg = 2'b00;
        
        case (ctrl)
            7'b0110011: begin // R-format
                alu_src_reg = 0;
                MemtoReg_reg = 0;
                RegWrite_reg = 1;
                MemRead_reg = 0;
                MemWrite_reg = 0;
                branch_reg = 0;
                alu_op_reg = 2'b10;
            end
            7'b0010011: begin // I-format (for immediate add)
                alu_src_reg = 1;
                MemtoReg_reg = 0;
                RegWrite_reg = 1;
                MemRead_reg = 0;
                MemWrite_reg = 0;
                branch_reg = 0;
                alu_op_reg = 2'b00;
            end
            7'b0000011: begin // Load (ld)
                alu_src_reg = 1;
                MemtoReg_reg = 1;
                RegWrite_reg = 1;
                MemRead_reg = 1;
                MemWrite_reg = 0;
                branch_reg = 0;
                alu_op_reg = 2'b00;
            end
            7'b0100011: begin // Store (sd)
                alu_src_reg = 1;
                MemtoReg_reg = 1'bx; // Don't care
                RegWrite_reg = 0;
                MemRead_reg = 0;
                MemWrite_reg = 1;
                branch_reg = 0;
                alu_op_reg = 2'b00;
            end
            7'b1100011: begin // Branch (beq)
                alu_src_reg = 0;
                MemtoReg_reg = 1'bx; // Don't care
                RegWrite_reg = 0;
                MemRead_reg = 0;
                MemWrite_reg = 0;
                branch_reg = 1;
                alu_op_reg = 2'b01;
            end
            default: begin
                // Default case to handle undefined opcodes
                branch_reg = 0;
                RegWrite_reg = 0;
                MemtoReg_reg = 0;
                MemRead_reg = 0;
                MemWrite_reg = 0;
                alu_src_reg = 0;
                alu_op_reg = 2'b00;
            end
        endcase
    end

    // Assign register values to output wires
    assign branch = branch_reg;
    assign RegWrite = RegWrite_reg;
    assign MemtoReg = MemtoReg_reg;
    assign MemRead = MemRead_reg;
    assign MemWrite = MemWrite_reg;
    assign alu_src = alu_src_reg;
    assign alu_op = alu_op_reg;

endmodule
