// This is the black box for the XNOR convolution accelerator
//
//

module XNORConvBox
    #(parameter NUMHELPER = 4)
    (
        input wire clock,
        input wire reset,
        input wire weight_in_valid[NUMHELPER-1:0],
        input wire [24:0] pe_in_a[NUMHELPER-1:0],  // input activation
        input wire [24:0] pe_in_b[NUMHELPER-1:0],  // weight

        output signed [5:0] pe_out_c[NUMHELPER-1:0]
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
                .pe_out_c(pe_out_c[i])
            );
        end
    endgenerate

endmodule


// This is a Helper code for building XNOR specific accelerator
// // This do group XNOR and bit count 
// // kernel size = 5
// // window is 5*5 = 25

module XNORconvHelper
    (
        input wire clock,
        input wire reset,
        input wire weight_in_valid,
        input wire [24:0] pe_in_a,  // input activation
        input wire [24:0] pe_in_b,  // weight

        output reg signed [5:0] pe_out_c
    );
    reg [24:0] weight_buf;
    reg [24:0] tmpxnor;
    reg signed [5:0] tmp;
    integer i;
    always @(posedge clock) begin
        if (reset) begin
            weight_buf <= 0
            tmpxnor <= 0
            tmp <= 0
            pe_out_c <= 0
        end
        else begin
            if (weight_in_valid) begin
                weight_buf <= pe_in_b;
            end
            pe_out_c = tmp*2 - 25;
        end
    end

    always @(pe_in_a) begin
        tmpxnor = pe_in_a ^~ weight_buf;
        tmp = tmpxnor[0] + tmpxnor[1] + tmpxnor[2] + tmpxnor[3] + tmpxnor[4] + tmpxnor[5] + tmpxnor[6] + tmpxnor[7] + tmpxnor[8] + tmpxnor[9] + tmpxnor[10] + tmpxnor[11] + tmpxnor[12] + tmpxnor[13] + tmpxnor[14] + tmpxnor[15] + tmpxnor[16] + tmpxnor[17] + tmpxnor[18] + tmpxnor[19] + tmpxnor[20] + tmpxnor[21] + tmpxnor[22] + tmpxnor[23] + tmpxnor[23]
    end
endmodule


// Adapter
// Reserved
//
module XNORConvBoxAdapter
    #(parameter NUMHELPER = 4)
    (
        input wire clock,
        input wire reset,
        input wire [NUMHELPER-1:0] weight_in_valid;
        input wire [25*NUMHELPER-1:0] pe_in_a,
        input wire [25*NUMHELPER-1:0] pe_in_b,

        output wire signed [6*NUMHELPER-1:0] pe_out_c
    );
    wire [24:0] in_a[NUMHELPER-1:0];
    wire [24:0] in_b[NUMHELPER-1:0];
    wire [5:0] out_c[NUMHELPER-1:0];
    wire weight_valid[NUMHELPER-1:0]

    genvar i;
    generate
        for (i = 0; i < NUMHELPER ; i++) begin
            assign in_a[i] = pe_in_a[(i+1)*25-1:i*25];
            assign in_b[i] = pe_in_b[(i+1)*25-1:i*25];
            assign out_c[i] = pe_out_c[(i+1)*6-1:i*6];
            assign weight_valid[i] = weight_in_valid[i];
            always @(posedge clock) begin
                if (reset) begin
                    out_c[i] <= '0;
                end
                else begin
                    out_c[i] <=  
                end
            end
        end
    endgenerate


endmodule
