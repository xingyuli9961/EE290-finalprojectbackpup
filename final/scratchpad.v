/*
 THis is working file for scratchpad design.
 Input, weight, output scratchpads will be derived from this.
 */

module scratchpad
    #(parameter NUMHELPER = 4, BITWIDTH=25, SIZE=256)
    (
        input wire clock,
        input wire write_enable,
        input [$clog2(SIZE+1)-1 : 0] address,
        input [$clog2(NUMHELPER+1)-1 : 0] data_mask,
        input [NUMHELPER*BITWIDTH-1:0] data_in,
        
        output [NUMHELPER*BITWIDTH-1:0] data_out
    );

    reg [BITWIDTH-1: 0] mem [$clog2(SIZE+1)-1 : 0];
    integer i;
    always @(posedge clock) begin
        if (write_enable) begin
            for (i=0; i<NUMHELPER ; i=i+1) begin
                if (data_maks[i]) begin
                    mem[address+i] <= data_in[(i+1)*BITWIDTH-1 : i*BITWIDTH];
                end
            end
        end
        for (i=0; i<NUMHELPER ; i=i+1) begin
            if (data_maks[i]) begin
                data_out[(i+1)*BITWIDTH-1 : i*BITWIDTH] <= mem[address+i];
            end
            else begin
                data_out[(i+1)*BITWIDTH-1 : i*BITWIDTH] <= 0;
            end
        end
    end


endmodule

