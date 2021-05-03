/*
 THis is working file for scratchpad design.
 Input, weight, output scratchpads will be derived from this.
 */

module scratchpad
    #(parameter NUMHELPER = 4, BITWIDTH=25, SIZE=256)
    (
        input wire clock,
        input wire on,
        input wire write_enable,
        input [$clog2(SIZE)-1 : 0] address,
        input [NUMHELPER-1 : 0] data_mask,
        input [NUMHELPER*BITWIDTH-1:0] data_in,
        
        output reg [NUMHELPER*BITWIDTH-1:0] data_out
    );

    reg [BITWIDTH-1: 0] mem [$clog2(SIZE)-1 : 0];
    genvar i;
    generate
        for (i=0; i<NUMHELPER ; i=i+1) begin
            always @(posedge clock) begin
                if (on) begin
                    if (write_enable) begin
                        if (data_mask[i]) begin
                            mem[address+i] <= data_in[(i+1)*BITWIDTH-1 : i*BITWIDTH];
                        end
                    end
                    else begin
                        if (data_mask[i]) begin
                            data_out[(i+1)*BITWIDTH-1 : i*BITWIDTH] <= mem[address+i];
                        end
                        else begin
                            data_out[(i+1)*BITWIDTH-1 : i*BITWIDTH] <= 0;
                        end
                    end
                end
                else begin
                    data_out <= 0;
                end
            end
        end
    endgenerate

endmodule

