module forward_mux(
input signed [63:0] ID_EX_rs1_value,
input signed [63:0] ID_EX_rs2_value,
input signed [63:0] EX_MEM_ALU_Out,
input signed [63:0] writeback_mux_value,
input [1:0] ForwardA,
input [1:0] ForwardB,
output signed [63:0] alu_in_A,
output signed [63:0] alu_in_B
);

        reg signed [63:0] alu_in_A_reg;
        reg signed [63:0] alu_in_B_reg;

        always @(*) begin
            case (ForwardA)
                2'b00: alu_in_A_reg = ID_EX_rs1_value;
                2'b01: alu_in_A_reg = writeback_mux_value;
                2'b10: alu_in_A_reg = EX_MEM_ALU_Out;
            endcase
            case (ForwardB)
                2'b00: alu_in_B_reg = ID_EX_rs2_value;
                2'b01: alu_in_B_reg = writeback_mux_value;
                2'b10: alu_in_B_reg = EX_MEM_ALU_Out;
            endcase
        end

        assign alu_in_A = alu_in_A_reg;
        assign alu_in_B = alu_in_B_reg;
        
endmodule 