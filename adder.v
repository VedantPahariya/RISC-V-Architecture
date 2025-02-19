module fa(a,b,c,sum,carry);

    input signed a,b,c;
    output signed sum,carry;
    wire d,e,f;

    xor(sum,a,b,c);
    and(d,a,b);
    and(e,b,c);
    and(f,c,a);
    or(carry,d,e,f);

endmodule

module ADD(rs1,rd);

    input signed [7:0] rs1;
    wire rs2;
    assign rs2 = 8'd4;
    output signed [7:0] rd;

    genvar i;
    generate  
        for(i = 0;i < 8;i = i + 1) begin
            fa FullAdder(rs1[i],rs2[i],carry[i],rd[i],carry[i+1]);
        end
    endgenerate

    EQUALSZERO eqz(zero_flag,rd);
    assign carry_flag = carry[64];
    xor(overflow_flag, carry_flag, carry[63]);

endmodule

module adder(
    input [7:0] address,      // PC address
    input [63:0] immgen,      // Immediate value
    input branch,             // Branch control signal
    input zero,               // Zero flag
    output wire [7:0] address_out // Output address
);

    wire [7:0] pc_plus_4;       // Holds address + 4
    wire [7:0] branch_target;   // Holds address + shifted immediate
    wire [7:0] imm_shifted;     // Shifted immediate value
    wire take_branch;           // AND of branch and zero

    // Increment PC by 4 without using '+'
    assign pc_plus_4 = {address[6:0], 1'b0} | 8'b00000100;

    // Shift immediate left by 1 (multiplication by 2)
    assign imm_shifted = {immgen[6:0], 1'b0}; 

    // Compute branch target address without using '+'
    // assign branch_target = address ^ imm_shifted; 
    // xor(branch_target, address, imm_shifted);

    // AND operation between branch and zero without using '&'
    // assign take_branch = ~(~branch | ~zero);
    and(take_branch, branch, zero); 

    // MUX to select between PC+4 or branch target
    assign address_out = (take_branch) ? branch_target : pc_plus_4;

endmodule
