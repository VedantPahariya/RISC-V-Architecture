module AND(rs1,rs2,rd,zero_flag);

    input signed [63:0] rs1,rs2;
    output signed [63:0] rd;
    output zero_flag;

    genvar i;
    generate 
        for(i = 0;i < 64;i = i + 1) begin
            and(rd[i], rs1[i], rs2[i]);
        end
    endgenerate

    EQUALSZERO eqz(zero_flag,rd);
   

endmodule

module OR(rs1,rs2,rd,zero_flag);

    input signed [63:0] rs1,rs2;
    output signed [63:0] rd;
    output zero_flag;

    genvar i;
    generate 
        for(i = 0;i < 64;i = i + 1) begin
            or(rd[i], rs1[i], rs2[i]);
        end
    endgenerate

    EQUALSZERO eqz(zero_flag,rd);
   

endmodule

module XOR(rs1,rs2,rd,zero_flag);

    input signed[63:0] rs1,rs2;
    output signed [63:0] rd;
    output zero_flag;

    genvar i;
    generate 
        for(i = 0;i < 64;i = i + 1) begin
            xor(rd[i], rs1[i], rs2[i]);
        end
    endgenerate

    EQUALSZERO eqz(zero_flag,rd);

endmodule

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


module ADD(rs1,rs2,rd,cin,zero_flag,carry_flag,overflow_flag);

    input signed [63:0] rs1,rs2;
    output signed [63:0] rd,zero;
    output zero_flag,carry_flag,overflow_flag;
    input cin;
    wire [64:0] carry;
    assign carry[0] = cin;

    genvar i;
    generate  
        for(i = 0;i < 64;i = i + 1) begin
            fa FullAdder(rs1[i],rs2[i],carry[i],rd[i],carry[i+1]);
        end
    endgenerate

    EQUALSZERO eqz(zero_flag,rd);
    assign carry_flag = carry[64];
    xor(overflow_flag, carry_flag, carry[63]);

endmodule

module NOT(rs1,rd);

    input signed [63:0] rs1;
    output signed [63:0] rd;

    genvar i;
    generate  
        for(i = 0;i < 64;i = i + 1) begin
            not(rd[i],rs1[i]);
        end
    endgenerate

endmodule

module SUB(rs1,rs2,rd,zero_flag,carry_flag,overflow_flag);

    input signed [63:0] rs1,rs2;
    input cin;
    output zero_flag,carry_flag,overflow_flag;
    output [63:0] rd,zero;
    wire [63:0] temp;

    NOT n(rs2,temp);
    ADD a(rs1,temp,rd,1'b1,zero_flag,carry_flag,overflow_flag);
    EQUALSZERO eqz(zero_flag,rd);

endmodule

// module SLL (
//     input signed [63:0] rs1, rs2,
//     output signed [63:0] rd,
//     output reg overflow_flag,
//     output reg carry_flag
// );

//     wire [5:0] shift;
//     assign shift = rs2[5:0];

//     wire [63:0] stage1, stage2, stage3, stage4, stage5, stage6;


//     assign stage1 = shift[0] ? {rs1[62:0], 1'b0} : rs1;
//     assign stage2 = shift[1] ? {stage1[61:0], 2'b0} : stage1;
//     assign stage3 = shift[2] ? {stage2[59:0], 4'b0} : stage2;
//     assign stage4 = shift[3] ? {stage3[55:0], 8'b0} : stage3;
//     assign stage5 = shift[4] ? {stage4[47:0], 16'b0} : stage4;
//     assign stage6 = shift[5] ? {stage5[31:0], 32'b0} : stage5;

//     assign rd = stage6;

//     // Carry Flag: Check if any bit that was shifted out was 1
//     always @(*) begin
//         carry_flag = 0;
//         case (shift)
//             6'd1: carry_flag = rs1[63];             
//             6'd2: carry_flag = |rs1[63:62];        
//             6'd4: carry_flag = |rs1[63:60];        
//             6'd8: carry_flag = |rs1[63:56];         
//             6'd16: carry_flag = |rs1[63:48];        
//             6'd32: carry_flag = |rs1[63:32];   
//             default: carry_flag = 0;
//         endcase
//     end

//     always @(*) begin
//         overflow_flag = xor x12(rs1[63], rd[63]);
//     end

// endmodule


module SLL(
    input signed [63:0] rs1,
    input signed [63:0] rs2,  
    output reg overflow_flag  
    output signed [63:0] rd,
    output reg carry_flag
);

    wire [5:0] shift;
    assign shift = rs2[5:0];

     wire [63:0] stage1, stage2, stage3, stage4, stage5, stage6;


    assign stage1 = shift[0] ? {rs1[62:0], 1'b0} : rs1;
    assign stage2 = shift[1] ? {stage1[61:0], 2'b0} : stage1;
    assign stage3 = shift[2] ? {stage2[59:0], 4'b0} : stage2;
    assign stage4 = shift[3] ? {stage3[55:0], 8'b0} : stage3;
    assign stage5 = shift[4] ? {stage4[47:0], 16'b0} : stage4;
    assign stage6 = shift[5] ? {stage5[31:0], 32'b0} : stage5;

    assign rd = stage6;

    wire signed [63:0] largest_pos, largest_neg;
    wire signed [63:0] pos_threshold, neg_threshold;
    wire signed [63:0] pos_check, neg_check;
    
    wire temp1;
    wire temp2;

    assign largest_pos = 64'h7FFF_FFFF_FFFF_FFFF;  
    assign largest_neg = 64'h8000_0000_0000_0000;  

    SRL shift_right_pos(largest_pos, rs2, pos_threshold,temp1,temp2);
    SRL shift_right_neg(largest_neg, rs2, neg_threshold,temp1,temp2);

    SLT signed_compare(rs1, pos_threshold, pos_check);
    SLT signed_compare_neg(rs1, neg_threshold, neg_check);

    always @(*) begin
        if (rs1 >= 0) 
            overflow_flag = pos_check[0]; 
        else 
            overflow_flag = neg_check[0]; 
    end


    always @(*) begin
        carry_flag = 0;
        case (shift)
            6'd1: carry_flag = rs1[63];             
            6'd2: carry_flag = |rs1[63:62];        
            6'd4: carry_flag = |rs1[63:60];        
            6'd8: carry_flag = |rs1[63:56];         
            6'd16: carry_flag = |rs1[63:48];        
            6'd32: carry_flag = |rs1[63:32];   
            default: carry_flag = 0;
        endcase
    end



endmodule

module SRL (rs1, rs2, rd,carry_flag,overflow_flag);
    input signed [63:0] rs1, rs2;
    output signed [63:0] rd;

    wire [5:0] shift;
    assign shift = rs2[5:0];

    wire [63:0] stage1, stage2, stage3, stage4, stage5;

    assign stage1 = shift[0] ? {1'b0, rs1[63:1]} : rs1;
    assign stage2 = shift[1] ? {2'b0, stage1[63:2]} : stage1;
    assign stage3 = shift[2] ? {4'b0, stage2[63:4]} : stage2;
    assign stage4 = shift[3] ? {8'b0, stage3[63:8]} : stage3;
    assign stage5 = shift[4] ? {16'b0, stage4[63:16]} : stage4;
    assign rd    = shift[5] ? {32'b0, stage5[63:32]} : stage5;

    assign carry_flag = |rs1[63-shift-1:0];

    assign overflow_flag = xor x12(rs1[63],rd[63]);


endmodule


module SRA (rs1, rs2, rd, carry_flag,overflow_flag);
    input signed [63:0] rs1, rs2;
    output signed [63:0] rd;
    output carry_flag;

    wire [5:0] shift;
    assign shift = rs2[5:0];

    wire [63:0] stage1, stage2, stage3, stage4, stage5;

    assign stage1 = shift[0] ? {rs1[63], rs1[63:1]} : rs1;
    assign stage2 = shift[1] ? {{2{rs1[63]}}, stage1[63:2]} : stage1;
    assign stage3 = shift[2] ? {{4{rs1[63]}}, stage2[63:4]} : stage2;
    assign stage4 = shift[3] ? {{8{rs1[63]}}, stage3[63:8]} : stage3;
    assign stage5 = shift[4] ? {{16{rs1[63]}}, stage4[63:16]} : stage4;
    assign rd    = shift[5] ? {{32{rs1[63]}}, stage5[63:32]} : stage5;

    assign carry_flag = |rs1[shift-1:0];

    assign overflow_flag = 1'b0;

endmodule



module SLT(rs1,rs2,rd);

    //subtract and output MSB XOR overflow bit (in 64 bit register)

    input signed [63:0] rs1,rs2;
    output signed [63:0] rd;
    wire [63:0] temp, temp2, temp3, shift;
    assign shift = 64'd63;
    wire zero_flag, carry_flag,overflow_flag;
    SUB s(rs1,rs2,temp,zero_flag, carry_flag,overflow_flag);
    SRL shift_right(temp,shift,temp2);
    assign temp3 = {{63'b0},overflow_flag};
    XOR x(temp2,temp3,rd,zero_flag);

    
endmodule

module EQUALSZERO(flag,rs1);

    input signed [63:0] rs1;
    output flag;
    wire [64:0] temp;
    assign temp[0]  = 1'b0;

    generate 
    genvar i;
    for(i = 0;i < 64;i = i + 1) begin
        or(temp[i+1], rs1[i], temp[i]);
    end
    endgenerate

    not(flag,temp[64]);

endmodule

module ISEQUAL(rs1,rs2,flag);

    // set flag

    input signed[63:0] rs1,rs2;
    output flag;
    wire [63:0] temp;
    wire zf;
    XOR x(rs1,rs2,temp,zf);
    EQUALSZERO eqz(flag,temp);

endmodule 

module SLTU(rs1,rs2,rd);

    // turned the unsigned comparison into signed by first flipping MSB
    // creating a mask for XOR by shifting 1 to the left by 63

    input signed [63:0] rs1,rs2;
    output signed [63:0] rd;
    wire [63:0] mask, t1,t2;
    wire zero_flag;
    SLL shift_left(64'd1,64'd63,mask);
    XOR x1(rs1,mask,t1,zero_flag);
    XOR x2(rs2,mask,t2,zero_flag);
    SLT comp(t1,t2,rd);

endmodule

