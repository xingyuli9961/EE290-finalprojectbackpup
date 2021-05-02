/*
 This is the unit test for an adapter of the XNOR convolution accelerator.
 */

module XNOR_adapterTest();
    reg clk, reset;
    reg [99:0] in_a;
    reg [99:0] in_b;
    wire unsigned [23:0] out_c;

    initial begin
        clk = 1'b0;
    end
    always #(5) clk <= ~clk;
    XNORconvBlackBox #(.NUMHELPER(4), .INPUT_BITWIDTH(25), .OUTPUT_BITWIDTH(6)) dut (
        .clock(clk),
        .reset(reset),
        .pe_in_a(in_a),
        .pe_in_b(in_b),
        .pe_out_c(out_c)
    );
    reg [23:0] result;
    reg [5:0] tmp [3:0];
    reg [23:0] check_buffer;

    integer i, j, k;   
    integer seed;

    initial begin
        $dumpfile("adapter.vcd");
        $dumpvars(0, dut);
        reset = 1'b1;
        result = 0;
        check_buffer = 0;

        @(posedge clk);
        reset = 1'b0;
        @(posedge clk);
        $display("test starts");
        for (i = 0; i < 20; i = i + 1) begin
            seed = i + 1;
            check_buffer = result;
            in_a[31:0] = $urandom(seed);
            in_a[63:32] = $urandom(seed);
            in_a[95:64] = $urandom(seed);
            in_a[99:96] = $urandom(seed);

            in_b[31:0] = $urandom(seed);
            in_b[63:32] = $urandom(seed);
            in_b[95:64] = $urandom(seed);
            in_b[99:96] = $urandom(seed);
            for (j = 0; j < 4; j = j + 1) begin
                tmp[j] = 0;
                for (k = 0; k < 25; k = k + 1) begin
                    tmp[j] = in_a[j*25+k]^~in_b[j*25+k] ? tmp[j] + 1 : tmp[j] -1;
                end
            end
            result[5:0] = tmp[0];
            result[11:6] = tmp[1];
            result[17:12] = tmp[2];
            result[23:18] = tmp[3];
            @(posedge clk);
            // $display("result: %b, check_buffer: %b, out_c: %b", result, check_buffer,  out_c);
            if (i>0) begin
                if (check_buffer != out_c) begin
                    $display("Fails: Expected: %b, but get: %b", result, out_c);
                end
            end
        end

        $finish();
    end



endmodule
