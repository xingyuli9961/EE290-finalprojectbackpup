// This is a Helper code for building XNOR specific accelerator
// This do group XNOR and bit count 
// this is a general case where we can tune the input and output bandwidth

module XNORconvSingle
    #(parameter INPUT_BITWIDTH=25, OUTPUT_BITWIDTH=6)
    (
        input wire reset,
        input wire [INPUT_BITWIDTH-1:0] pe_in_a,  // input activation
        input wire [INPUT_BITWIDTH-1:0] pe_in_b,  // weight

        output reg signed [OUTPUT_BITWIDTH-1:0] pe_out_c
    );
    reg [INPUT_BITWIDTH-1:0] tmpxnor;
    reg signed [OUTPUT_BITWIDTH-1:0] tmp;
    integer i;
    always @(*) begin
        if (reset) begin
            tmpxnor = 0;
            tmp = 0;
            pe_out_c = 0;
        end 
        else begin 
            tmpxnor = pe_in_a ^~ pe_in_b;
            tmp = 0;
            for (i=0;i<INPUT_BITWIDTH;i=i+1) begin
                tmp = tmp + tmpxnor[i];
            end
            pe_out_c = tmp*2 - 25;
        end
    end
endmodule
