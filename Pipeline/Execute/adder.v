module fa_beq(a,b,c,sum,carry);
    input signed a,b,c;
    output signed sum,carry;
    wire d,e,f;

    xor(sum,a,b,c);
    and(d,a,b);
    and(e,b,c);
    and(f,c,a);
    or(carry,d,e,f);

endmodule

module ADD_beq(rs1,rs2,rd);

    input signed [63:0] rs1,rs2;
    output signed [7:0] rd;
    wire [63:0] sum;
    wire [64:0] carry;
    assign carry[0] = 1'b0;

    genvar i;
    generate  
        for(i = 0;i < 64; i = i + 1) begin
            fa_beq FullAdder(rs1[i],rs2[i],carry[i],sum[i],carry[i+1]);
        end
    endgenerate

    assign rd = sum[7:0];
endmodule


module adder(
    input signed[7:0] address,      // PC address
    input signed [63:0] immgen,      // Immediate value
    output [7:0] branch_target // Output address
);

  //  wire [63:0] branch_target_64;   // Holds address + shifted immediate
    wire signed [63:0] imm_shifted;     // Shifted immediate value

    // extending the 8 bit address to 64 bit address
    wire [63:0] address1;
    assign address1 = {{56{1'b0}}, address[7:0]};

    // Shift immediate left by 1 (multiplication by 2)
    assign imm_shifted = {immgen[62:0], 1'b0}; 
    
    wire signed[7:0] branch_target_8;
    // Add 64-bit address1 and shifted immediate value
    ADD_beq add_inst2 (.rs1(address1), .rs2(imm_shifted), .rd(branch_target_8));

    assign branch_target = branch_target_8;

    always @(*) begin
        $display("PC in branch adder: %d", address);
        $display("immediate in branch adder: %d", immgen);
        $display("branch_target: %d", branch_target);
    end
endmodule
