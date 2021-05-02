/*
 This is the unit test for a single PE of the accelerator.
 Note: In the current simulator, we need to first set the in_b, and then in the next cycle raise up the in_valid.
 */

module XNOR_unitTest;
    reg clk, reset;
    reg [24:0] in_a;
    reg [24:0] in_b;
    wire [5:0] out_c;

    initial begin
        clk = 1'b0;
    end
    always #(5) clk <= ~clk;

    XNORconvSingle #(.INPUT_BITWIDTH(25), .OUTPUT_BITWIDTH(6)) dut (.reset(reset), .pe_in_a(in_a), .pe_in_b(in_b), .pe_out_c(out_c));
    initial begin
        $dumpfile("unit.vcd");
        $dumpvars(0, dut);
        $dumpvars(0, clk);
        reset = 1'b1;
        in_a = 25'b0;
        in_b = 25'b0;

        repeat (2) @(posedge clk);
        reset = 1'b0;
        in_b = 25'h1FFFFFF;
        in_a = 25'b01;
        @(posedge clk);
        in_a = 25'b0;
        @(posedge clk);
        in_a = 25'b1010101010101010101010101; 
        @(posedge clk);
        in_a = 25'h1FFFFFF;
        @(posedge clk);
        in_b = 25'b0;
        in_a = 25'b0;
        @(posedge clk);
        in_a = 25'b01;
        @(posedge clk);
        in_a = 25'b1010101010101010101010101;
        @(posedge clk);
        in_a = 25'h1FFFFFF;
        @(posedge clk);
        in_a = 25'h 1000001;
        in_b = 25'h 0100010;
        @(posedge clk);
        in_a = 25'h 1010101;
        in_b = 25'h 0101010; 
        repeat (5) @(posedge clk);

        $finish();
    end

endmodule

