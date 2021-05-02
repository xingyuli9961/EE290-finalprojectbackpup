// This is the black box for the XNOR convolution accelerator
//

module XNORconvBlackBox
    #(parameter NUMHELPER = 4, INPUT_BITWIDTH=25, OUTPUT_BITWIDTH=6)
    (
        input wire clock,
        input wire reset,
        input wire [INPUT_BITWIDTH*NUMHELPER-1:0] pe_in_a,
        input wire [INPUT_BITWIDTH*NUMHELPER-1:0] pe_in_b,

        output wire [OUTPUT_BITWIDTH*NUMHELPER-1:0] pe_out_c
    );

    wire [INPUT_BITWIDTH-1:0] in_a [NUMHELPER-1:0];
    wire [INPUT_BITWIDTH-1:0] in_b [NUMHELPER-1:0];
    wire [OUTPUT_BITWIDTH-1:0] out_c [NUMHELPER-1:0];
    reg [OUTPUT_BITWIDTH-1:0] reg_out_c [NUMHELPER-1:0];

    genvar i;
    generate 
        for (i = 0; i < NUMHELPER ; i = i+1) begin
            assign in_a[i] = pe_in_a[(i+1)*INPUT_BITWIDTH-1 : i*INPUT_BITWIDTH];
            assign in_b[i] = pe_in_b[(i+1)*INPUT_BITWIDTH-1 : i*INPUT_BITWIDTH];
            assign pe_out_c[(i+1)*OUTPUT_BITWIDTH-1 : i*OUTPUT_BITWIDTH] = reg_out_c[i];

            always @(posedge clock) begin
                if (reset) begin
                    reg_out_c[i] <= 0;
                end
                else begin
                    reg_out_c[i] <= out_c[i];
                end
            end
            XNORconvSingle #(.INPUT_BITWIDTH(INPUT_BITWIDTH), .OUTPUT_BITWIDTH(OUTPUT_BITWIDTH)) dut (
                .reset(reset),
                .pe_in_a(in_a[i]),
                .pe_in_b(in_b[i]),
                .pe_out_c(out_c[i])
            );

        end
    endgenerate
endmodule

