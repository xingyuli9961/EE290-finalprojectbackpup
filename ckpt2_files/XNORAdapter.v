// Thi is the code to wrap aroud the accelerator
//
//
module XNORAdapter
    #(parameter NUMHELPER = 4)
    (
        input wire clock,
        input wire reset,
        input wire weight_in_valid[NUMHELPER-1:0],
        input wire [31:0] pe_in_a[NUMHELPER-1:0],  // input activation
        input wire [24:0] pe_in_b[NUMHELPER-1:0],  // weight

        output reg signed [5:0] pe_out_c[NUMHELPER-1:0]
    );
    genvar i;
    generate
        for (i = 0; i < NUMHELPER; i += 1) begin
            XNORconvHelper xnorconvhp (
                .clock(clock),
                .reset(reset),
                .weight_in_valid(weight_in_valid[i]),
                .pe_in_a(pe_in_a[i]),
                .pe_in_b(pe_in_b[i]),
                .pe_out_c(pe_out_c[0])
            );
        end
    endgenerate

endmodule
