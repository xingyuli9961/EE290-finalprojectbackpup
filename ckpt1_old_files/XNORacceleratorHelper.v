// This is a Helper code for building XNOR specific accelerator
// This do group XNOR and bit count
//
//

module XNORnetHelper
    #(parameter INPUT_BITWIDTH, OUTPUT_BITWIDTH)
    (
        input wire clock,
        input wire reset,
        input wire signed [INPUT_BITWIDTH-1:0] pe_in_a,  // input activation
        input wire signed [INPUT_BITWIDTH-1:0] pe_in_b,  // weight
        input wire signed [5: 0] activeNum,              // active or valid bits in the input
        
        output reg signed [OUTPUT_BITWIDTH-1:0] pe_out_c
    );
    reg signed [INPUT_BITWIDTH-1:0] tmpxnor;
    reg signed [5:0] tmp;
    integer i;
    always @(posedge clock) begin
        // reset everything to 0
        if (reset) begin
            pe_out_c <= 0;
        end
        else begin
            tmp = 0;
            tmpxnor = pe_in_a ^~ pe_in_b;
            for (i = 0; i < activeNum; i=i+1) {
                tmp = tmp + tmpxnor[i];
            }
            pe_out_c = tmp - activeNum;
        end
    end


endmodule
