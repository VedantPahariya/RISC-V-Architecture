module fa1(a,b,c,sum,carry);

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
            fa1 fa1_inst(rs1[i],rs2[i],carry[i],rd[i],carry[i+1]);
        end
    endgenerate

endmodule

module pc_increment(
    input signed[7:0] curr_addr,      // PC address
    input signed[7:0] branch_target, // Branch target address
    input branch,                   // Branch control signal
    input zero_flag,                // Zero flag
    output [7:0] address_out,        // Output address
    output PCsrc                    // Branch control signal // AND of branch and zero
);

    wire [7:0] pc_plus_4;       // Holds address + 4

    // Increment PC by 4 using ADD module
    ADD4 add_inst (.rs1(curr_addr), .rd(pc_plus_4));
    
    wire signed[7:0] branch_target_8;
    
    // PCsrc for the MUX select line
    and(PCsrc, branch, zero_flag); 

    // MUX for the brach_target and pc_plus_4
    assign address_out = PCsrc ? branch_target : pc_plus_4;

    always @(*) begin
        $display("branch_target: %b", branch_target);
    end

endmodule
