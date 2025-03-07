module forwarding_unit(
input [4:0] ID_EX_rs1,
input [4:0] ID_EX_rs2,
input [4:0] EX_MEM_rd,
input [4:0] MEM_WB_rd,
input EX_MEM_regWrite,
input MEM_WB_regWrite,
output [1:0] fwd_A,
output [1:0] fwd_B
);
        reg [1:0] fwd_A_reg;
        reg [1:0] fwd_B_reg;

        always @(*) begin
        if (EX_MEM_regWrite && (EX_MEM_rd != 0) && (EX_MEM_rd ==ID_EX_rs1))
            fwd_A_reg = 10;
        else  
            if ((MEM_WB_regWrite && (MEM_WB_rd != 0) && (MEM_WB_rd ==ID_EX_rs1)))
                fwd_A_reg = 01;
            else 
                fwd_A_reg=00;
        if (EX_MEM_regWrite && (EX_MEM_rd != 0) && (EX_MEM_rd ==ID_EX_rs2))
            fwd_B_reg = 10;
        else 
            if ((MEM_WB_regWrite && (MEM_WB_rd != 0) && (MEM_WB_rd ==ID_EX_rs2) ))
                 fwd_B_reg = 01;
            else 
                 fwd_B_reg=00;
        end
        
        assign fwd_A = fwd_A_reg;
        assign fwd_B = fwd_B_reg;
        
endmodule 