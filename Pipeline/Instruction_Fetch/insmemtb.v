`include "Instruction_mem.v"
`include "pc.v"
`include "pc_increment.v"
`include "../Registers/IF_ID.v"
`timescale 1ns / 1ns

module tb_instruction_fetch;
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
    
    // Instantiate PC Adder (fixed the port syntax error)
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

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end
    
    // Test stimulus
    initial begin
        // Initialize inputs
        branch = 0;           // No branch for now
        zero_flag = 0;        // No zero flag
        branch_target = 8'd0; // Default branch target
        
        // Create a VCD file for waveform viewing
        $dumpfile("instruction_fetch.vcd");
        $dumpvars(0, tb_instruction_fetch);
        
        // Display header for simulation output
        $display("Time\tPC\tInstruction\tNext PC");
        $display("-----------------------------------------");
        
        // Run for multiple clock cycles to fetch several instructions
        #100; // Run for 100ns (10 clock cycles)
        
        $display("\nIF/ID Register Final State:");
        $display("PC_out: %d, Instruction: %h", pc_out, instruction_out);
        $display("Control: %b, rd: %d, rs1: %d, rs2: %d", ctrl, rd, rs1, rs2);
        
        $finish;
    end
    
    // Monitor PC and instruction values
    always @(posedge clk) begin
        #1; // Small delay to let signals settle
        $display("%0t\t%d\t0x%h\t%d", $time, pc, instruction, next_pc);
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