/*
 This is a simple counter to help profiling
 */
module counter (
    input clk,
    input rstn,
    output reg [19:0] out
);
    always @(posedge clk) begin
        if (!rstn) begin
            out <= 0;
        end
        else begin
            out <= out + 1;
        end
    end

endmodule
