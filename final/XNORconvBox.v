// This is the black box for the XNOR convolution accelerator
//

module XNORConvBox
    #(parameter NUMHELPER = 4, INPUT_BITWIDTH=25, OUTPUT_BITWIDTH=6)
    (
        input wire clock,
        input wire reset,
        input wire [INPUT_BITWIDTH-1:0] pe_in_a[NUMHELPER-1:0],  // input activation
        input wire [INPUT_BITWIDTH-1:0] pe_in_b[NUMHELPER-1:0],  // weight

        output signed [OUTPUT_BITWIDTH-1:0] pe_out_c[NUMHELPER-1:0]
    );
    genvar i;
    generate
        for (i=0; i NUMHELPER; i+=1) begin
            XNORconvSingle #(.INPUT_BITWIDTH(25), .OUTPUT_BITWIDTH(6)) dut(
                .reset(reset),
                .pe_in_a(pe_in_a[i]),
                .pe_in_b(pe_in_b[i]),
                .pe_out_c(pe_out_c[i])
            );
        end
    endgenerate
endmodule
