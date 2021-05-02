// This is a Helper code for building XNOR specific accelerator
// This do group XNOR and bit count 
// kernel size = 5
// window is 5*5 = 25

module XNORconvHelper
    (
        input wire reset,
        input wire [24:0] pe_in_a,  // input activation
        input wire [24:0] pe_in_b,  // weight

        output wire signed [5:0] pe_out_c
    );
    wire [24:0] tmpxnor;
    wire signed [5:0] tmp;
    assign tmpxnor = reset ? 0 : pe_in_a ^~ pe_in_b;
    assign tmp = reset ? 0 : tmpxnor[0] + tmpxnor[1] + tmpxnor[2] + tmpxnor[3] + tmpxnor[4] + tmpxnor[5] + tmpxnor[6] + tmpxnor[7] + tmpxnor[8] + tmpxnor[9] + tmpxnor[10] + tmpxnor[11] + tmpxnor[12] + tmpxnor[13] + tmpxnor[14] + tmpxnor[15] + tmpxnor[16] + tmpxnor[17] + tmpxnor[18] + tmpxnor[19] + tmpxnor[20] + tmpxnor[21] + tmpxnor[22] + tmpxnor[23] + tmpxnor[24];
    assign pe_out_c = reset ? 0 : tmp*2 - 25;
endmodule
