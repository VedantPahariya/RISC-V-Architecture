// writing module to read from ins.mem
module read();
    wire [6:0] ctrl;
    wire [7:0] address;
    assign address = 8'd0;
    reg [7:0] memory [0:255];

    initial begin
        $readmemh("ins.mem", memory); // Read memory in hex format
        // #1;
        // Print first few memory locations to verify contents
        $display("Memory[0] = %h", memory[0]);
        $display("Memory[1] = %h", memory[1]);
        $display("Memory[2] = %h", memory[2]);
        $display("Memory[3]sfs = %h", memory[4]);
    end

    assign ctrl = memory[0][6:0];

    // print ctrl
    initial begin
        #1
        $display("Memory[3] = %b", memory[4][6:0]);
        $display("%b", ctrl);
    end
endmodule