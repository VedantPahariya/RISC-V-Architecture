`timescale 1ns/1ps
`include "alu.v"

module ALU_tb();
    reg [63:0] rs1, rs2;
    reg [3:0] control;
    wire [63:0] rd;
    wire zero, carry, overflow;

    // Instantiate ALU
    ALU alu_inst(
        .rs1(rs1),
        .rs2(rs2),
        .control(control),
        .rd(rd),
        .zero(zero),
        .carry(carry),
        .overflow(overflow)
    );

    initial begin

        //equate the signed values when checking the cases

        $dumpfile("test.vcd");
        $dumpall;
        // Test case 1: AND
        rs1 = 64'h963A3CEA6A85A3EE;
        rs2 = 64'hD4F3E912A738F764;
        $display("rs1: %b", rs1);
        $display("rs2: %b", rs2);
        control = 4'b0000;
        #10;
        $display("Expected output: %b", rs1 & rs2);
        $display("Received output: %b", rd);
        $display("Zero flag: %b", zero);
        if ($signed(rd) !== $signed(rs1 & rs2)) $display("AND test failed");
        else $display("AND test passed");

        // Test case 2: OR
        control = 4'b0001;
        #10;
        $display("Expected output: %b", rs1 | rs2);
        $display("Received output: %b", rd);
        $display("Zero flag: %b", zero);
        if ($signed(rd) !== $signed(rs1 | rs2)) $display("OR test failed");
        else $display("OR test passed");

        // Test case 3: ADD
        rs1 = 64'hB2F06D2187EEAB45;
        rs2 = 64'h987D972FD9376CF3;
    
        $display("rs1: %b", rs1);
        $display("rs2: %b", rs2);
        control = 4'b0010;
        #10;
        $display("Expected output: %b", rs1 + rs2);
        $display("Received output: %b", rd);
        $display("Zero flag: %b", zero);
        $display("Carry flag: %b", carry);
        $display("Overflow flag: %b", overflow);
        if ($signed(rd) !== $signed(rs1+rs2)) $display("ADD test failed");
        else $display("ADD test passed");

        // Test case 4: XOR
        rs1 = 64'h2545E8117780F3E7;
        rs2 = 64'hE7BA0399A8CD20DA;
        $display("rs1: %b", rs1);
        $display("rs2: %b", rs2);
        control = 4'b0011;
        #10;
        $display("Expected output: %b", rs1 ^ rs2);
        $display("Received output: %b", rd);
        $display("Zero flag: %b", zero);
        if ($signed(rd) !== $signed(rs1 ^ rs2)) $display("XOR test failed");
        else $display("XOR test passed");

        // Test case 5: SLL
        rs1 = 64'hDE56B55E0266D8E0;
        rs2 = 64'h82AA21D87A9EEEBC;
        $display("rs1: %b", rs1);
        $display("rs2: %b", rs2);
        control = 4'b0100;
        #10;
        $display("Expected output: %b", rs1 << rs2[5:0]);
        $display("Received output: %b", rd);
        if ($signed(rd) !== $signed(rs1 << rs2[5:0])) $display("SLL test failed");
        else $display("SLL test passed");

        // Test case 6: SRL
        rs1 = 64'hEC4169206C2C4A34;
        rs2 = 64'hEB81B2596AB3B8E9;
        $display("rs1: %b", rs1);
        $display("rs2: %b", rs2);
        control = 4'b0101;
        #10;
        $display("Expected output: %b", rs1 >> rs2[5:0]);
        $display("Received output: %b", rd);
        if ($signed(rd) !== $signed(rs1 >> rs2[5:0])) $display("SRL test failed");
        else $display("SRL test passed");

        // Test case 7: SUB
        rs1 = 64'h9FF9303D1306FD72;
        rs2 = 64'h39CD56ED93021F9A;
        $display("rs1: %b", rs1);
        $display("rs2: %b", rs2);
        control = 4'b0110;
        #10;
        $display("Expected output: %b", rs1 - rs2);
        $display("Received output: %b", rd);
        $display("Zero flag: %b", zero);
        $display("Carry flag: %b", carry);
        $display("Overflow flag: %b", overflow);
        if ($signed(rd) !== $signed(rs1 - rs2)) $display("SUB test failed");
        else $display("SUB test passed");

        // Test case 8: SRA
        rs1 = 64'h5AAE2DB6BF1EC801;
        rs2 = 64'h46CC2BCFDF7D45B6;
        $display("rs1: %b", rs1);
        $display("rs2: %b", rs2);

        control = 4'b0111;
        #10;

        $display("Expected output: %b", ($signed(rs1) >>> rs2[5:0]));
        $display("Received output: %b", $signed(rd));
        if ($signed(rd) != ($signed(rs1) >>> rs2[5:0])) $display("SRA test failed");
        else $display("SRA test passed");

        // Test case 9: SLT
        rs1 = 64'h3B2BF5EDA940C529;
        rs2 = 64'h78B12B127AF99DD5;
        $display("rs1: %b", rs1);
        $display("rs2: %b", rs2);
        control = 4'b1000;
        #10;
        $display("Expected output: %b", $signed(rs1) < $signed(rs2) ? 64'd1 : 64'd0);
        $display("Received output: %b", rd);
        if (rd != ($signed(rs1) < $signed(rs2) ? 64'd1 : 64'd0)) $display("SLT test failed");
        else $display("SLT test passed");

        // Test case 10: SLTU
        rs1 = 64'h373E508A6AB95FD9;
        rs2 = 64'h64D026204AED0734;
        $display("rs1: %b", rs1);
        $display("rs2: %b", rs2);
        control = 4'b1001;
        #10;
        $display("Expected output: %b", rs1 < rs2 ? 64'd1 : 64'd0);
        $display("Received output: %b", rd);
        if ($signed(rd) != (rs1 < rs2 ? 64'd1 : 64'd0)) $display("SLTU test failed");
        else $display("SLTU test passed");

        $display("All tests completed");
        $finish;
    end

endmodule