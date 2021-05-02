/*
 This is the unit test for a box of the PEs.
 */

module XNOR_boxTest();
    reg clk, reset;
    reg [24:0] in_a [3:0];
    reg [24:0] in_b [3:0];
    wire signed [5:0] out_c [3:0];

    initial begin
        clk = 1'b0;
    end
    always #(5) clk <= ~clk;

    XNORConvBox #(.NUMHELPER(4), .INPUT_BITWIDTH(25), .OUTPUT_BITWIDTH(6)) dut (.reset(reset), .pe_in_a(in_a), .pe_in_b(in_b), .pe_out_c(out_c));
     
    reg signed [5:0] result [3:0];
    integer i, j, k;

    initial begin
        $dumpfile("box.vcd");
        $dumpvars(0, dut);
        $dumpvars(0, clk);
        reset = 1'b1;
        @(posedge clk);

        reset = 1'b0;
        @(posedge clk);

        for (i = 0; i < 20; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                in_a[j] = $urandom(i+1);
                in_b[j] = $urandom(i+1);
            end
            for (j = 0; j < 4; j = j + 1) begin
                result[j] = 0;
                for (k = 0; k < 25; k = k + 1) begin
                    result[j] = in_a[j][k]^~in_b[j][k] ? result[j] + 1 : result[j] - 1;
                end
            end
            for (j = 0; j < 4; j = j +  1) begin
                if (result[j] != out_c[j]) begin
                    $display("Expected: %b, but get: %b", result[j], out_c[j]);
                end
            end
        end
        $finish();
    end


endmodule
