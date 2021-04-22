// This is a Helper code for building XNOR specific accelerator
//  This do group XNOR and bit count 
//

module XNORconvHelperLogic
    #(parameter INPUT_BITWIDTH = 32, OUTPUT_BITWIDTH = 7)
    (
        input wire clock,
        input wire reset,
        input wire weight_in_valid,
        input wire [INPUT_BITWIDTH-1:0] pe_in_a,  // input activation
        input wire [INPUT_BITWIDTH-1:0] pe_in_b,  // weight

        output reg signed [OUTPUT_BITWIDTH-1:0] pe_out_c
    );
    reg [INPUT_BITWIDTH-1:0] weight_buf;
    reg [INPUT_BITWIDTH-1:0] tmpxnor;
    reg signed [5:0] tmp;
    integer i;
    always @(posedge clock) begin 
        // reset everything to 0
        if (reset) begin
            weight_buf <= 0
            tmpxnor <= 0
            tmp <= 0
            pe_out_c <= 0
        end
        else begin
            tmp = 0;
            tmpxnor = weight_buf ^~ pe_in_a;
            for (i = 0; i < INPUT_BITWIDTH; i=i+1) {
                 tmp = tmp + tmpxnor[i];
            }
            pe_out_c = tmp*2 - INPUT_BITWIDTH;
        end
    end
endmodule
