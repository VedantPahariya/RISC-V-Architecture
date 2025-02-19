`include "ops.v"

// carry flag : add two n bit binary numbers and consider the output to be unsigned. If value doesnt lie within [0,2^n-1] set carry
// overflow flag: add two n bit binary numbers and consider the output to be signed. If the number does not lie within [-2^(n-1), 2^(n-1)-1] set overflow

module ALU(rs1,rs2,control,rd, zero, carry, overflow);

    input signed [63:0] rs1,rs2;
    input [3:0] control;
    output signed [63:0] rd;
    output zero,carry,overflow;

    // register outputs
    reg [63:0] ALU_output;
    reg zero_output, carry_output, overflow_output;

    assign rd = ALU_output;
    assign zero = zero_output;
    assign carry = carry_output;
    assign overflow = overflow_output;

    wire [63:0] add_out, sub_out, and_out, or_out, xor_out, sll_out, srl_out, sra_out, slt_out, sltu_out;
    wire add_zero, sub_zero, and_zero, or_zero,xor_zero;
    wire add_carry, sub_carry;
    wire add_overflow, sub_overflow;

    // Hardware modules cannot be generated in an always block
    ADD add_inst (rs1,rs2,add_out,1'b0,add_zero,add_carry,add_overflow);
    SUB sub_inst (rs1,rs2,sub_out,sub_zero,sub_carry,sub_overflow);
    AND and_inst (rs1,rs2,and_out,and_zero);
    OR or_inst (rs1,rs2,or_out,or_zero);
    XOR xor_inst (rs1,rs2,xor_out,xor_zero);
    SLL sll_inst (rs1,rs2,sll_out);
    SRL srl_inst (rs1,rs2,srl_out);
    SRA sra_inst (rs1,rs2,sra_out);
    SLT slt_inst (rs1,rs2,slt_out);
    SLTU sltu_inst (rs1,rs2,sltu_out);

    always@(*) begin

        case(control)
        // 4'b0000 : AND

            4'b0000 : begin
                ALU_output = and_out;
                zero_output = and_zero;
            end

        // 4'b0001 : OR
                
                4'b0001 : begin
                    ALU_output = or_out;
                    zero_output = or_zero;
                end
           
        // 4'b0010 : ADD
            
                4'b0010 : begin
                    ALU_output = add_out;
                    zero_output = add_zero;
                    carry_output = add_carry;
                    overflow_output = add_overflow;
                end

        // 4'b0011 : XOR
                4'b0011 : begin
                    ALU_output = xor_out;
                    zero_output = xor_zero;
                end

        // 4'b0100 : SLL
                    
                    4'b0100 : begin
                        ALU_output = sll_out;
                    end


        // 4'b0101 : SRL
                4'b0101 : begin
                    ALU_output = srl_out;
                end

        // 4'b0110 : SUB
                4'b0110 : begin
                    ALU_output = sub_out;
                    zero_output = sub_zero;
                    carry_output = sub_carry;
                    overflow_output = sub_overflow;
                end

        // 4'b0111 : SRA
                4'b0111 : begin
                    ALU_output = sra_out;
                end
                
        // 4'b1000 : SLT
                4'b1000 : begin
                    ALU_output = slt_out;
                end

        // 4'b1001 : SLTU
                4'b1001 : begin
                    ALU_output = sltu_out;
                end
    
        endcase
    
    end

endmodule