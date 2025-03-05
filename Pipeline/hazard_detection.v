//here i am including the mux also 
//and the controll signals also included.
module hazard_detection_unit(
    input [4:0] IF_ID_rs1,
    input [4:0] IF_ID_rs2,
    input [4:0] ID_EX_rd,
    input ID_EX_MemRead,
    input [6:0] control,
    output reg stall,
    output reg IF_ID_Write,
    output reg PC_Write,
    );
    
    
    always @(*) begin
        if (((IF_ID_rs1 == ID_EX_rd) || (IF_ID_rs2 == ID_EX_rd)) && ID_EX_MemRead && (ID_EX_rd != 0))
            stall = 1;
        else
            stall = 0;
    end

   

     always @(*) begin
        if (stall) begin
            IF_ID_Write = 0;  
            PC_Write = 0;     
        end else begin
            IF_ID_Write = 1; 
            PC_Write = 1;
        end
    end

    //now we have to check for the control signals and accordingly set the values
    //if the stall is 1 then set everything to 0 or else the previous values as it is.

    
endmodule



module hazard_detection_unit(
    input [4:0] IF_ID_rs1,
    input [4:0] IF_ID_rs2,
    input [4:0] ID_EX_rd,
    input ID_EX_MemRead,
    input [6:0] ctrl, // Opcode input to the control unit
    output reg stall,
    output reg IF_ID_Write,
    output reg PC_Write,
    output reg branch,
    output reg RegWrite,
    output reg MemtoReg,
    output reg MemRead,
    output reg MemWrite,
    output reg alu_src,
    output reg [1:0] alu_op
);

    reg branch_reg, RegWrite_reg, MemtoReg_reg, MemRead_reg, MemWrite_reg, alu_src_reg;
    reg [1:0] alu_op_reg;

    //this checks for stalling 
    always @(*) begin
        if (((IF_ID_rs1 == ID_EX_rd) || (IF_ID_rs2 == ID_EX_rd)) && ID_EX_MemRead && (ID_EX_rd != 0))
            stall = 1;  // Stall detected
        else
            stall = 0;  // No hazard, proceed normally
    end

     //now if stalling is there we use the mux and accordingly we give 0 as input i.e set 
    //everything to 0 or else send the normal values
    
    //stopping writting and incrementing the PC
    always @(*) begin
        if (stall) begin
            IF_ID_Write = 0;  
            PC_Write = 0;     
        end else begin
            IF_ID_Write = 1;  
            PC_Write = 1;
        end
    end

    //now if stalling is there then we have to stop all the operations , so accordingly we do it.
    always @(*) begin
        if (stall) begin
            branch = 0;
            RegWrite = 0;
            MemtoReg = 0;
            MemRead = 0;
            MemWrite = 0;
            alu_src = 0;
            alu_op = 2'b00;
            
        end else begin
            case (ctrl)
                7'b0110011: begin // R-format
                    alu_src = 0;
                    MemtoReg = 0;
                    RegWrite = 1;
                    MemRead = 0;
                    MemWrite = 0;
                    branch = 0;
                    alu_op = 2'b10;
                end
                7'b0010011: begin // I-format (Immediate add)
                    alu_src = 1;
                    MemtoReg = 0;
                    RegWrite = 1;
                    MemRead = 0;
                    MemWrite = 0;
                    branch = 0;
                    alu_op = 2'b00;
                end
                7'b0000011: begin // Load (ld)
                    alu_src = 1;
                    MemtoReg = 1;
                    RegWrite = 1;
                    MemRead = 1;
                    MemWrite = 0;
                    branch = 0;
                    alu_op = 2'b00;
                end
                7'b0100011: begin // Store (sd)
                    alu_src = 1;
                    MemtoReg = 1'bx; // Don't care
                    RegWrite = 0;
                    MemRead = 0;
                    MemWrite = 1;
                    branch = 0;
                    alu_op = 2'b00;
                end
                7'b1100011: begin // Branch (beq)
                    alu_src = 0;
                    MemtoReg = 1'bx; // Don't care
                    RegWrite = 0;
                    MemRead = 0;
                    MemWrite = 0;
                    branch = 1;
                    alu_op = 2'b01;
                end
                default: begin
                    branch = 0;
                    RegWrite = 0;
                    MemtoReg = 0;
                    MemRead = 0;
                    MemWrite = 0;
                    alu_src = 0;
                    alu_op = 2'b00;
                end
            endcase
        end
    end

endmodule
