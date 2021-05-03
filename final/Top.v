/*
 I assembly the scratch pad with the accelerator at this level
 */

module Top
    #(parameter NUMHELPER = 4, INPUT_BITWIDTH=25, OUTPUT_BITWIDTH=6, SIZE=16)
    (
        input wire clock,
        input [NUMHELPER*BITWIDTH-1:0] data_in_weight,
        input [NUMHELPER*BITWIDTH-1:0] data_in_input,,

        output reg [NUMHELPER*BITWIDTH-1:0] data_out
    );



endmodule
