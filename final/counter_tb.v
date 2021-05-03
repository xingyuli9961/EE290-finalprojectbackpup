module counter_tb();
    reg clk, resetn;
    wire [19:0] out;
    initial begin
        clk = 1'b0;
    end 
    always #(5) clk <= ~clk;
    counter dut (.clk(clk), .rstn(resetn), .out(out));

    initial begin
        resetn = 1'b0;
        @(posedge clk);
        @(posedge clk);
        $display("%b", out);
        resetn = 1'b1;
        @(posedge clk);
        @(posedge clk);

        $display("%d", out);
        repeat (100) @(posedge clk);
        $display("%d", out);

        $finish();

    end


endmodule
