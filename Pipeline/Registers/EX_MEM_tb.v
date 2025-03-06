`timescale 1ns / 1ps

module EX_MEM_tb;

    // Inputs
    reg clk;
    reg [63:0] ALU_data;
    reg [63:0] rd_data;
    reg [63:0] rs_2_in;
    reg [31:0] pc_branch_in;
    reg zero;
    reg [4:0] Rd;
    reg MemtoReg;
    reg regwrite;
    reg branch;
    reg MemRead;
    reg MemWrite;

    // Outputs
    wire [31:0] pc_branch_out;
    wire [63:0] ALU_data_out;
    wire [63:0] rd_data_out;
    wire [63:0] rs_2_out;
    wire zero_out;
    wire MemtoReg_out;
    wire regwrite_out;
    wire branch_out;
    wire MemRead_out;
    wire MemWrite_out;
    wire [4:0] EX_MEM_rd;

    // Instantiate the Unit Under Test (UUT)
    EX_MEM uut (
        .clk(clk),
        .ALU_data(ALU_data),
        .rd_data(rd_data),
        .rs_2_in(rs_2_in),
        .pc_branch_in(pc_branch_in),
        .zero(zero),
        .Rd(Rd),
        .MemtoReg(MemtoReg),
        .regwrite(regwrite),
        .branch(branch),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .pc_branch_out(pc_branch_out),
        .ALU_data_out(ALU_data_out),
        .rd_data_out(rd_data_out),
        .rs_2_out(rs_2_out),
        .zero_out(zero_out),
        .MemtoReg(MemtoReg_out),
        .regwrite(regwrite_out),
        .branch(branch_out),
        .MemRead(MemRead_out),
        .MemWrite(MemWrite_out),
        .EX_MEM_rd(EX_MEM_rd)
    );

    // Initialize VCD file
    initial begin
        $dumpfile("EX_MEM_tb.vcd");
        $dumpvars(0, EX_MEM_tb);
    end

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        ALU_data = 64'd0;
        rd_data = 64'd0;
        rs_2_in = 64'd0;
        pc_branch_in = 32'd0;
        zero = 0;
        Rd = 5'd0;
        MemtoReg = 0;
        regwrite = 0;
        branch = 0;
        MemRead = 0;
        MemWrite = 0;

        // Wait a few clock cycles
        #10;

        // Test Case 1: Load operation
        ALU_data = 64'd100;      // Memory address
        rd_data = 64'd5;         // Destination register
        rs_2_in = 64'd200;       // Source register 2
        pc_branch_in = 32'd300;  // Branch target
        zero = 0;                // Not zero result
        Rd = 5'd10;              // Register destination
        MemtoReg = 1;            // Load from memory
        regwrite = 1;            // Write to register
        branch = 0;              // Not branch
        MemRead = 1;             // Read from memory
        MemWrite = 0;            // No write to memory
        
        #10;
        
        // Verify outputs
        $display("Test Case 1: Load operation");
        $display("ALU_data_out = %d, expected = %d", ALU_data_out, ALU_data);
        $display("rd_data_out = %d, expected = %d", rd_data_out, rd_data);
        $display("rs_2_out = %d, expected = %d", rs_2_out, rs_2_in);
        $display("pc_branch_out = %d, expected = %d", pc_branch_out, pc_branch_in);
        $display("zero_out = %d, expected = %d", zero_out, zero);
        $display("MemtoReg_out = %d, expected = %d", MemtoReg_out, MemtoReg);
        $display("regwrite_out = %d, expected = %d", regwrite_out, regwrite);
        $display("branch_out = %d, expected = %d", branch_out, branch);
        $display("MemRead_out = %d, expected = %d", MemRead_out, MemRead);
        $display("MemWrite_out = %d, expected = %d", MemWrite_out, MemWrite);
        $display("EX_MEM_rd = %d, expected = %d", EX_MEM_rd, Rd);
        
        // Test Case 2: Store operation
        ALU_data = 64'd150;      // Memory address
        rd_data = 64'd15;        // Destination register  
        rs_2_in = 64'd250;       // Data to store
        pc_branch_in = 32'd350;  // Branch target
        zero = 0;                // Not zero result
        Rd = 5'd20;              // Register destination
        MemtoReg = 0;            // No load from memory
        regwrite = 0;            // No write to register
        branch = 0;              // Not branch
        MemRead = 0;             // No read from memory
        MemWrite = 1;            // Write to memory
        
        #10;
        
        // Verify outputs
        $display("Test Case 2: Store operation");
        $display("ALU_data_out = %d, expected = %d", ALU_data_out, ALU_data);
        $display("rd_data_out = %d, expected = %d", rd_data_out, rd_data);
        $display("rs_2_out = %d, expected = %d", rs_2_out, rs_2_in);
        $display("pc_branch_out = %d, expected = %d", pc_branch_out, pc_branch_in);
        $display("zero_out = %d, expected = %d", zero_out, zero);
        $display("MemtoReg_out = %d, expected = %d", MemtoReg_out, MemtoReg);
        $display("regwrite_out = %d, expected = %d", regwrite_out, regwrite);
        $display("branch_out = %d, expected = %d", branch_out, branch);
        $display("MemRead_out = %d, expected = %d", MemRead_out, MemRead);
        $display("MemWrite_out = %d, expected = %d", MemWrite_out, MemWrite);
        $display("EX_MEM_rd = %d, expected = %d", EX_MEM_rd, Rd);
        
        // Test Case 3: Branch operation
        ALU_data = 64'd200;      // ALU result (comparison)
        rd_data = 64'd25;        // Destination register
        rs_2_in = 64'd300;       // Source register 2
        pc_branch_in = 32'd400;  // Branch target
        zero = 1;                // Zero result (branch taken)
        Rd = 5'd30;              // Register destination
        MemtoReg = 0;            // No load from memory
        regwrite = 0;            // No write to register
        branch = 1;              // Branch instruction
        MemRead = 0;             // No read from memory
        MemWrite = 0;            // No write to memory
        
        #10;
        
        // Verify outputs
        $display("Test Case 3: Branch operation");
        $display("ALU_data_out = %d, expected = %d", ALU_data_out, ALU_data);
        $display("rd_data_out = %d, expected = %d", rd_data_out, rd_data);
        $display("rs_2_out = %d, expected = %d", rs_2_out, rs_2_in);
        $display("pc_branch_out = %d, expected = %d", pc_branch_out, pc_branch_in);
        $display("zero_out = %d, expected = %d", zero_out, zero);
        $display("MemtoReg_out = %d, expected = %d", MemtoReg_out, MemtoReg);
        $display("regwrite_out = %d, expected = %d", regwrite_out, regwrite);
        $display("branch_out = %d, expected = %d", branch_out, branch);
        $display("MemRead_out = %d, expected = %d", MemRead_out, MemRead);
        $display("MemWrite_out = %d, expected = %d", MemWrite_out, MemWrite);
        $display("EX_MEM_rd = %d, expected = %d", EX_MEM_rd, Rd);
        
        #20;
        $finish;
    end

endmodule
