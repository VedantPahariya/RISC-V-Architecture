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

module ADD4(rs1,rd);

    // adds 4 in 8 bit addition
    input signed [7:0] rs1;
    wire [7:0] rs2;
    assign rs2 = 8'd4;  // need to add 4 to the PC address
    output signed [7:0] rd;

    wire [8:0] carry;
    assign carry[0] = 1'b0;

    genvar i;
    generate  
        for(i = 0;i < 8;i = i + 1) begin
            fa FullAdder(rs1[i],rs2[i],carry[i],rd[i],carry[i+1]);
        end
    endgenerate

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
    input [7:0] address,      // PC address
    input [63:0] immgen,      // Immediate value
    input branch,             // Branch control signal
    input zero_flag,               // Zero flag
    output [7:0] address_out // Output address
);

    wire [7:0] pc_plus_4;       // Holds address + 4
  //  wire [63:0] branch_target_64;   // Holds address + shifted immediate
    wire [63:0] imm_shifted;     // Shifted immediate value
    wire PCsrc;           // AND of branch and zero

    // extending the 8 bit address to 64 bit address
    wire [63:0] address1;
    assign address1 = {{56{1'b0}}, address[7:0]};

    // Increment PC by 4 using ADD module
    ADD4 add_inst (.rs1(address), .rd(pc_plus_4));

    // Shift immediate left by 1 (multiplication by 2)
    assign imm_shifted = {immgen[62:0], 1'b0}; 
    always @(immgen) begin #1
        $display("\n --> adder: immgen:%d imm_shifted:%d zero_flag:%d",immgen, imm_shifted,zero_flag);
    end
    
    wire [7:0] branch_target_8;
    // Add 64-bit address1 and shifted immediate value
    ADD_beq add_inst2 (.rs1(address1), .rs2(imm_shifted), .rd(branch_target_8));

    
   // assign branch_target_8 = branch_target_64[7:0];
    // PCsrc for the MUX select line
    and(PCsrc, branch, zero_flag); 

    // MUX for the brach_target and pc_plus_4
    assign address_out = PCsrc ? branch_target_8 : pc_plus_4;
endmodule
