// This is a Helper code for building XNOR specific accelerator
// This do group XNOR and bit count 
// kernel size = 5
// window is 5*5 = 25

module XNORconvSingle
    (
        input wire reset,
        input wire [24:0] pe_in_a,  // input activation
        input wire [24:0] pe_in_b,  // weight

        output reg signed [5:0] pe_out_c
    );
    reg [24:0] tmpxnor;
    reg signed [5:0] tmp;
    always @(*) begin
        if (reset) begin
            tmpxnor = 0;
            tmp = 0;
            pe_out_c = 0;
        end 
        else begin 
            tmpxnor = pe_in_a ^~ pe_in_b;
            tmp = tmpxnor[0] + tmpxnor[1] + tmpxnor[2] + tmpxnor[3] + tmpxnor[4] + tmpxnor[5] + tmpxnor[6] + tmpxnor[7] + tmpxnor[8] + tmpxnor[9] + tmpxnor[10] + tmpxnor[11] + tmpxnor[12] + tmpxnor[13] + tmpxnor[14] + tmpxnor[15] + tmpxnor[16] + tmpxnor[17] + tmpxnor[18] + tmpxnor[19] + tmpxnor[20] + tmpxnor[21] + tmpxnor[22] + tmpxnor[23] + tmpxnor[24];
            pe_out_c = tmp*2 - 25;
        end
    end
endmodule
