`timescale 1ns/1ps
`include "control.v"

module control_tb();
    // Inputs
    reg [6:0] ctrl;
    
    // Outputs
    wire branch;
    wire RegWrite;
    wire MemtoReg;
    wire MemRead; 
    wire MemWrite;
    wire alu_src;
    wire [1:0] alu_op;
    
    // Instantiate the Unit Under Test (UUT)
    control uut (
        .ctrl(ctrl),
        .branch(branch),
        .RegWrite(RegWrite),
        .MemtoReg(MemtoReg),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .alu_src(alu_src),
        .alu_op(alu_op)
    );
    
    // For displaying test results
    reg [31:0] test_num = 0;
    reg [7:0] passed = 0;
    reg [7:0] failed = 0;
    
    // Helper task to verify control signals
    task check_signals;
        input [6:0] opcode;
        input expected_branch;
        input expected_RegWrite;
        input expected_MemtoReg;
        input expected_MemRead;
        input expected_MemWrite;
        input expected_alu_src;
        input [1:0] expected_alu_op;
        input [100:0] instr_name;
        begin
            test_num = test_num + 1;
            ctrl = opcode;
            #10; // Wait for signals to propagate
            
            if (branch === expected_branch && 
                RegWrite === expected_RegWrite &&
                (expected_MemtoReg === 1'bx || MemtoReg === expected_MemtoReg) &&
                MemRead === expected_MemRead &&
                MemWrite === expected_MemWrite &&
                alu_src === expected_alu_src &&
                alu_op === expected_alu_op) begin
                $display("Test %d (%s): PASSED", test_num, instr_name);
                passed = passed + 1;
            end else begin
                $display("Test %d (%s): FAILED", test_num, instr_name);
                $display("  Opcode: %b", opcode);
                $display("  Expected: branch=%b, RegWrite=%b, MemtoReg=%b, MemRead=%b, MemWrite=%b, alu_src=%b, alu_op=%b",
                          expected_branch, expected_RegWrite, expected_MemtoReg, expected_MemRead, 
                          expected_MemWrite, expected_alu_src, expected_alu_op);
                $display("  Actual:   branch=%b, RegWrite=%b, MemtoReg=%b, MemRead=%b, MemWrite=%b, alu_src=%b, alu_op=%b",
                          branch, RegWrite, MemtoReg, MemRead, MemWrite, alu_src, alu_op);
                failed = failed + 1;
            end
        end
    endtask
    
    // Monitor changes
    initial begin
        $monitor("Time: %0d, Opcode: %b, branch: %b, RegWrite: %b, MemtoReg: %b, MemRead: %b, MemWrite: %b, alu_src: %b, alu_op: %b",
                 $time, ctrl, branch, RegWrite, MemtoReg, MemRead, MemWrite, alu_src, alu_op);
    end
    
    // Test cases
    initial begin
        // Test R-format (add, sub, and, or, etc.)
        check_signals(7'b0110011, 0, 1, 0, 0, 0, 0, 2'b10, "R-format");
        
        // Test Load instruction (ld)
        check_signals(7'b0000011, 0, 1, 1, 1, 0, 1, 2'b00, "Load");
        
        // Test Store instruction (sd)
        check_signals(7'b0100011, 0, 0, 1'bx, 0, 1, 1, 2'b00, "Store");
        
        // Test Branch instruction (beq)
        check_signals(7'b1100011, 1, 0, 1'bx, 0, 0, 0, 2'b01, "Branch");
        
        // Test undefined opcode (should apply default values)
        check_signals(7'b1111111, 0, 0, 0, 0, 0, 0, 2'b00, "Undefined opcode");
        
        // Additional test cases for other RISC-V instructions (not defined in your control unit)
        // Uncomment if you plan to extend your control unit
        // I-format arithmetic (addi, etc) - using a placeholder opcode
        // check_signals(7'b0010011, 0, 1, 0, 0, 0, 1, 2'b10, "I-type Arithmetic");
        
        // Summary
        #10;
        $display("\n--- Test Summary ---");
        $display("Total tests: %d", test_num);
        $display("Passed: %d", passed);
        $display("Failed: %d", failed);
        
        if (failed == 0)
            $display("All tests PASSED!");
        else
            $display("Some tests FAILED!");
            
        $finish;
    end
    
endmodule
