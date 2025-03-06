`timescale 1ns / 1ns
`include "../Registers/IF_ID.v"
`include "../Registers/ID_EX.v"
`include "../Instruction_Fetch/Instruction_mem.v"
`include "../Instruction_Fetch/pc.v"
`include "../Instruction_Fetch/pc_increment.v"
`include "control.v"
`include "registers.v"
`include "immgen.v"

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
    
    // New wires for monitoring ID/EX outputs
    wire signed [63:0] rs1_data_id_ex, rs2_data_id_ex, rd_data_id_ex, imm_id_ex;
    wire MemtoReg_id_ex, regwrite_id_ex, branch_id_ex, MemRead_id_ex, MemWrite_id_ex, alu_src_id_ex;
    wire [1:0] alu_op_id_ex;

    // Instantiate Program Counter
    program_counter pc_inst (
        .clk(clk),
        .next_addr(next_pc),
        .curr_addr(pc)
    );

    // Instantiate Instruction Memory
    insmem inst_mem (
        .curr_addr(pc),
        .instruction(instruction)
    );
    
    // Instantiate PC Adder
    pc_increment pc_adder (
        .curr_addr(pc),
        .branch_target(branch_target),
        .branch(branch),
        .zero_flag(zero_flag),
        .address_out(next_pc)
    );
    
    // Instantiate IF/ID Register
    IF_ID if_id_reg (
        .clk(clk),
        .instruction_in(instruction),
        .pc_in(pc),
        .ctrl(ctrl),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .instruction_out(instruction_out),
        .pc_out(pc_out)
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
        .alu_op(alu_op)
    );

    // Instantiate Register File
    register register_file (
        .clk(clk),
        .wrt_data(64'd0), // Placeholder for actual write data
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .RegWrite(regwrite),
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
        .rs1_data_out(rs1_data_id_ex),  // Now monitored
        .rs2_data_out(rs2_data_id_ex),  // Now monitored
        .rd_data_out(rd_data_id_ex),    // Now monitored
        .imm_out(imm_id_ex),            // Now monitored
        .MemtoReg_out(MemtoReg_id_ex),      // Now monitored
        .regwrite_out(regwrite_id_ex),      // Now monitored
        .branch_out(branch_id_ex),          // Now monitored
        .MemRead_out(MemRead_id_ex),        // Now monitored
        .MemWrite_out(MemWrite_id_ex),      // Now monitored
        .alu_src_out(alu_src_id_ex),        // Now monitored
        .alu_op_out(alu_op_id_ex),          // Now monitored
        .instruction_out(instruction_out_id_ex),
        .rs1(rs1_id_ex),
        .rs2(rs2_id_ex),
        .rd(rd_id_ex)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end
    
    // Monitor values using negedge to ensure values are stable
    always @(negedge clk) begin
        $display("%0t\tPC=%d\tInstruction=0x%h\tNext PC=%d", 
                 $time, pc, instruction, next_pc);
    end
    
    // Test stimulus
    initial begin
        // Initialize inputs
        branch = 0;           // No branch for now
        zero_flag = 0;        // No zero flag
        branch_target = 8'd0; // Default branch target
        
        // Create a VCD file for waveform viewing
        $dumpfile("instruction_decode.vcd");
        $dumpvars(0, tb_instruction_decode);
        
        // Display header for simulation output
        $display("Time\tPC\tInstruction\tNext PC");
        $display("-----------------------------------------");
        
        // Run for multiple clock cycles to fetch several instructions
        #200; // Run for 200ns (20 clock cycles)
        
        // Display final state information
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
        
        $finish;
    end

    // Test case validation
    initial begin
        // Check if instruction memory file exists
        if (!$fopen("../Instructions.mem", "r")) begin
            $display("ERROR: Instructions.mem file not found!");
            $finish;
        end
    end

endmodule