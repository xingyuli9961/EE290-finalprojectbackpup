/*
 This is an optional experimental block.
 */
module data_transformer 
    #(parameter MAXNUM = 25, WORD_BITWIDTH=32)
    (
        input [MAXNUM*WORD_BITWIDTH-1:0] data_in,
        output [MAXNUM-1:0] data_out
    );
    genvar i;
    generate
        for (i=0; i< MAXNUM; i = i+1) begin
            assign data_out[i] = data_in[(i+1)*WORD_BITWIDTH-1] ? 1'b0 : 1'b1;
        end
    endgenerate

endmodule

