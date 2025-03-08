`timescale 1ns / 1ns
`include "./Registers/IF_ID.v"
`include "./Registers/ID_EX.v"
`include "./Registers/MEM_WB.v"
`include "./Registers/EX_MEM.v"
`include "./Instruction_Fetch/Instruction_mem.v"
`include "./Instruction_Fetch/pc.v"
`include "./Instruction_Fetch/pc_increment.v"
`include "./Instruction_Decode/control.v"
`include "./Instruction_Decode/registers.v"
`include "./Instruction_Decode/immgen.v"
`include "./Instruction_Decode/hazard_detection.v"
// Additional includes for Execute and Memory stages
`include "./Execute/alu.v"
`include "./Execute/alu_control.v"
`include "./Execute/forward_muxes.v"
`include "./Execute/adder.v"
`include "./Data_Memory/mem.v"
`include "./Writeback/writeback_mux.v"
`include "./Execute/forwarding_unit.v"

module tb_instruction_decode;
    // Inputs
    reg clk;
    reg branch;
    reg zero_flag;
    reg [7:0] branch_target;
    
    // Outputs
    wire [31:0] instruction;
    wire [7:0] pc;
    wire [7:0] next_pc;
    
    // IF/ID Register outputs
    wire [6:0] ctrl;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [31:0] instruction_out;
    wire [7:0] pc_out;

    // ID/EX Register input wires
    wire signed [63:0] rs1_data_out, rs2_data_out, rd_data_out, imm_out;
    
    // ID/EX Register output wires
    wire [7:0] pc_out_id_ex;
    wire [31:0] instruction_out_id_ex;
    wire [4:0] rs1_id_ex, rs2_id_ex, rd_id_ex;
    wire MemtoReg, regwrite, branch_out, MemRead, MemWrite, alu_src;
    wire [1:0] alu_op;
    
    // ID/EX Register output monitoring wires
    wire signed [63:0] rs1_data_id_ex, rs2_data_id_ex, rd_data_id_ex, imm_id_ex;
    wire MemtoReg_id_ex, regwrite_id_ex, branch_id_ex, MemRead_id_ex, MemWrite_id_ex, alu_src_id_ex;
    wire [1:0] alu_op_id_ex;

    // Execute stage wires
    wire [3:0] alu_control_op;
    wire signed [63:0] alu_result;
    wire alu_zero;
    wire alu_carry;
    wire alu_overflow;
    wire signed [63:0] alu_input2;  // Second input to ALU (either rs2 or immediate)

    // EX/MEM Register wires
    wire [7:0] branch_target_out_ex_mem;
    wire [4:0] EX_MEM_rd;
    wire MemtoReg_ex_mem, regwrite_ex_mem, branch_ex_mem, MemRead_ex_mem, MemWrite_ex_mem;
    wire zero_out_ex_mem;
    wire signed [63:0] ALU_data_out_ex_mem, rd_data_out_ex_mem;

    // Memory stage wires
    wire signed [63:0] data_out;

    // MEM/WB Register wires
    wire [4:0] MEM_WB_rd;
    wire MemtoReg_mem_wb, regwrite_mem_wb;
    wire signed [63:0] ALU_data_out_mem_wb, read_Data_out_mem_wb;
    wire signed [63:0] write_back_data;

    wire signed [63:0] alu_in1, alu_in2;
 // Forwarding Unit wires
    wire [1:0] fwd_A, fwd_B;

    wire pc_write;
    wire IF_ID_Write;
    wire stall;
    wire pcsrc;
    wire [7:0] branch_target_input_ex_mem;

    // Instantiate Program Counter
    program_counter pc_inst (
        .clk(clk),
        .next_addr(next_pc),
        .curr_addr(pc),
        .PC_Write(pc_write)
    );

    // Instantiate Instruction Memory
    insmem inst_mem (
        .curr_addr(pc),
        .instruction(instruction)
    );
    
    // Instantiate PC Adder
    pc_increment pc_adder (
        .curr_addr(pc),
        .branch_target(branch_target_out_ex_mem),
        .branch(branch_ex_mem),
        .zero_flag(zero_out_ex_mem),
        .address_out(next_pc),
        .PCsrc(pcsrc)
    );

    adder adder_inst (
        .address(pc_out_id_ex),
        .immgen(imm_id_ex),
        .branch_target(branch_target_input_ex_mem) // previously pc_out_id_ex
    );

    IF_ID if_id_reg (
        .clk(clk),
        .PCsrc(pcsrc),
        .instruction_in(instruction),
        .pc_in(pc),
        .ctrl(ctrl),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .instruction_out(instruction_out),
        .pc_out(pc_out),
        .IF_ID_Write(IF_ID_Write)
    );

    // Instantiate Control Unit
    control control_unit (
        .ctrl(ctrl),
        .branch(branch_out),
        .RegWrite(regwrite),
        .MemtoReg(MemtoReg),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .alu_src(alu_src),
        .alu_op(alu_op),
        .stall(stall)
    );

    // Instantiate Register File
    register register_file (
        .clk(clk),
        .wrt_data(write_back_data),
        .rs1(rs1),
        .rs2(rs2),
        .rd(MEM_WB_rd),
        .RegWrite(regwrite_mem_wb),
        .read_data_1(rs1_data_out),
        .read_data_2(rs2_data_out),
        .read_data_rd(rd_data_out)
    );

    // Instantiate Immediate Generator
    imm_gen imm_generator (
        .instruction(instruction_out),
        .imm(imm_out)
    );

    // Instantiate ID/EX Register
    ID_EX id_ex_reg (
        .clk(clk),
        .PCsrc(pcsrc),
        .rs1_data(rs1_data_out),
        .rs2_data(rs2_data_out),
        .rd_data(rd_data_out),
        .imm_gen(imm_out),
        .pc_in(pc_out),
        .MemtoReg(MemtoReg),
        .regwrite(regwrite),
        .branch(branch_out),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .alu_src(alu_src),
        .alu_op(alu_op),
        .instruction(instruction_out),
        .IF_ID_rs1(rs1),
        .IF_ID_rs2(rs2),
        .IF_ID_rd(rd),
        .pc_out(pc_out_id_ex),
        .rs1_data_out(rs1_data_id_ex),
        .rs2_data_out(rs2_data_id_ex),
        .rd_data_out(rd_data_id_ex),
        .imm_out(imm_id_ex),
        .MemtoReg_out(MemtoReg_id_ex),
        .regwrite_out(regwrite_id_ex),
        .branch_out(branch_id_ex),
        .MemRead_out(MemRead_id_ex),
        .MemWrite_out(MemWrite_id_ex),
        .alu_src_out(alu_src_id_ex),
        .alu_op_out(alu_op_id_ex),
        .instruction_out(instruction_out_id_ex),
        .rs1(rs1_id_ex),
        .rs2(rs2_id_ex),
        .rd(rd_id_ex)
    );

    // ALU input mux
    assign alu_in2 = alu_src_id_ex ? imm_id_ex : alu_input2;

    // Instantiate ALU Control
    alucontrol alu_ctrl (
        .instruction(instruction_out_id_ex),
        .alu_op(alu_op_id_ex),
        .alu_control_op(alu_control_op)
    );

    // Instantiate ALU
    ALU alu_unit (
        .rs1(alu_in1),
        .rs2(alu_in2),
        .control(alu_control_op),
        .rd(alu_result),              
        .zero(alu_zero),              
        .carry(alu_carry),            
        .overflow(alu_overflow)       
    );

    forward_mux forward_mux_inst (
        .ID_EX_rs1_value(rs1_data_id_ex),
        .ID_EX_rs2_value(rs2_data_id_ex),
        .EX_MEM_ALU_Out(ALU_data_out_ex_mem),
        .writeback_mux_value(write_back_data),
        .ForwardA(fwd_A),
        .ForwardB(fwd_B),
        .alu_in_A(alu_in1),
        .alu_in_B(alu_input2)
    );

    forwarding_unit forward_unit (
        .ID_EX_rs1(rs1_id_ex),
        .ID_EX_rs2(rs2_id_ex),
        .EX_MEM_rd(EX_MEM_rd),
        .MEM_WB_rd(MEM_WB_rd),
        .EX_MEM_regWrite(regwrite_ex_mem),
        .MEM_WB_regWrite(regwrite_mem_wb),
        .fwd_A(fwd_A),
        .fwd_B(fwd_B)
    );

    // Instantiate EX/MEM Register with corrected port names
    EX_MEM ex_mem_reg (
        .clk(clk),
        .PCsrc(pcsrc),
        .ALU_data(alu_result),           
        .rd_data(alu_input2),        
        .branch_target(branch_target_input_ex_mem),  //previously pc_out_id_ex  
        .zero(alu_zero),                 
        .Rd(rd_id_ex),                   
        .MemtoReg(MemtoReg_id_ex),       
        .regwrite(regwrite_id_ex),       
        .branch(branch_id_ex),           
        .MemRead(MemRead_id_ex),         
        .MemWrite(MemWrite_id_ex),       
        .branch_target_out(branch_target_out_ex_mem),  
        .ALU_data_out(ALU_data_out_ex_mem),      
        .rd_data_out(rd_data_out_ex_mem),        
        .zero_out(zero_out_ex_mem),
        .EX_MEM_rd(EX_MEM_rd),           
        .MemtoReg_out(MemtoReg_ex_mem),
        .regwrite_out(regwrite_ex_mem),
        .branch_out(branch_ex_mem),
        .MemRead_out(MemRead_ex_mem),
        .MemWrite_out(MemWrite_ex_mem)
    );

    // Note: mem.v needs to add clk as an input port since it uses it
    // Instantiate Data Memory with corrected port names
    mem data_mem (
        .clk(clk),   
        .address(ALU_data_out_ex_mem),
        .data_in(rd_data_out_ex_mem),  
        .MemWrite(MemWrite_ex_mem),
        .MemRead(MemRead_ex_mem),
        .data_out(data_out)      
    );

    // Instantiate MEM/WB Register with corrected port names
    MEM_WB mem_wb_reg (
        .clk(clk),
        .ALU_data(ALU_data_out_ex_mem),     
        .read_Data(data_out),               
        .EX_MEM_rd(EX_MEM_rd),              
        .MemtoReg(MemtoReg_ex_mem),         
        .regwrite(regwrite_ex_mem),         
        .ALU_data_out(ALU_data_out_mem_wb), 
        .read_Data_out(read_Data_out_mem_wb), 
        .MEM_WB_rd(MEM_WB_rd),              
        .MemtoReg_out(MemtoReg_mem_wb),
        .regwrite_out(regwrite_mem_wb)
    );

    wb_mux write_back_mux (
        .alu_out(ALU_data_out_mem_wb),
        .mem_out(read_Data_out_mem_wb), 
        .writeback(write_back_data),
        .MemtoReg(MemtoReg_mem_wb)
    );

    hazard_detection_unit hazard_detection_unit_inst (
        .IF_ID_rs1(rs1),
        .IF_ID_rs2(rs2),
        .ID_EX_rd(rd_id_ex),
        .ID_EX_MemRead(MemRead_id_ex),
        .stall(stall),
        .IF_ID_Write(IF_ID_Write),
        .PC_Write(pc_write)
    );

    // Write back mux
    // assign write_back_data = MemtoReg_mem_wb ? read_Data_out_mem_wb : ALU_data_out_mem_wb;

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end
    
    // Monitor values using negedge to ensure values are stable
    always @(negedge clk) begin
        $display("%0t\tPC=%d\tInstruction=0x%h\tNext PC=%d", 
                 $time, pc, instruction, next_pc);

    // Monitor x11 through register file interface
     if (MEM_WB_rd == 5'd31 && regwrite_mem_wb && write_back_data != 0) begin
        $display("x11 updated to non-zero value (%d), exiting simulation", write_back_data);
        $finish;
    end
    end
    
    // Test stimulus
    initial begin
        // Initialize inputs
        // branch = 0;           // No branch for now
        // zero_flag = 0;        // No zero flag
        // branch_target = 8'd0; // Default branch target
        
        // Create a VCD file for waveform viewing
        $dumpfile("full_pipeline.vcd");
        $dumpvars(0, tb_instruction_decode);
        
        // Display header for simulation output
        $display("Time\tPC\tInstruction\tNext PC");
        $display("-----------------------------------------");
        
        // Run for multiple clock cycles to fetch several instructions
        #2000; // Run for 300ns (30 clock cycles) - more time needed for full pipeline
        
        // Display final state information for all pipeline stages
        $display("\nIF/ID Register Final State:");
        $display("PC_out: %d, Instruction: %h", pc_out, instruction_out);
        $display("Control: %b, rd: %d, rs1: %d, rs2: %d", ctrl, rd, rs1, rs2);
        
        $display("\nID/EX Register Final State:");
        $display("PC_out: %d, Instruction: %h", pc_out_id_ex, instruction_out_id_ex);
        $display("rs1_data: %d, rs2_data: %d, rd_data: %d", rs1_data_id_ex, rs2_data_id_ex, rd_data_id_ex);
        $display("imm_value: %d", imm_id_ex);
        $display("Control signals:");
        $display("MemtoReg: %b, RegWrite: %b, Branch: %b", MemtoReg_id_ex, regwrite_id_ex, branch_id_ex);
        $display("MemRead: %b, MemWrite: %b, ALU_Src: %b, ALU_Op: %b", 
                 MemRead_id_ex, MemWrite_id_ex, alu_src_id_ex, alu_op_id_ex);
        $display("rd: %d, rs1: %d, rs2: %d", rd_id_ex, rs1_id_ex, rs2_id_ex);
        
        $display("\nExecute Stage Final State:");
        $display("ALU Control: %b", alu_control_op);
        $display("ALU Result: %d, Zero: %b", alu_result, alu_zero);
        
        $display("\nEX/MEM Register Final State:");
        $display("ALU Result: %d, Zero: %b", ALU_data_out_ex_mem, zero_out_ex_mem);
        $display("RS2 Data: %d, rd: %d", rd_data_out_ex_mem, EX_MEM_rd);
        $display("Control signals:");
        $display("MemtoReg: %b, RegWrite: %b, Branch: %b", MemtoReg_ex_mem, regwrite_ex_mem, branch_ex_mem);
        $display("MemRead: %b, MemWrite: %b", MemRead_ex_mem, MemWrite_ex_mem);
        
        $display("\nMemory Stage Final State:");
        $display("Memory Read Data: %d", data_out);
        
        $display("\nMEM/WB Register Final State:");
        $display("ALU Result: %d, Memory Data: %d", ALU_data_out_mem_wb, read_Data_out_mem_wb);
        $display("rd: %d", MEM_WB_rd);
        $display("Control signals:");
        $display("MemtoReg: %b, RegWrite: %b", MemtoReg_mem_wb, regwrite_mem_wb);
        
        $display("\nWrite Back Stage Final State:");
        $display("Write Back Data: %d", write_back_data);
        
        $finish;
    end

    // Test case validation
    initial begin
        // Check if instruction memory file exists
        if (!$fopen("./Instructions.mem", "r")) begin
            $display("ERROR: Instructions.mem file not found!");
            $finish;
        end
    end

endmodule