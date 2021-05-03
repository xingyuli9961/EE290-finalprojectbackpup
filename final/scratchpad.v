/*
 THis is working file for scratchpad design.
 Input, weight, output scratchpads will be derived from this.
 */

module scratchpad
    #(parameter NUMHELPER = 4, BITWIDTH=25, SIZE=16)
    (
        input wire clock,
        input wire on,
        input wire write_enable,
        input [$clog2(SIZE)-1 : 0] address,
        input [NUMHELPER*BITWIDTH-1:0] data_in,
        
        output reg [NUMHELPER*BITWIDTH-1:0] data_out
    );

    reg [NUMHELPER*BITWIDTH-1: 0] mem [SIZE-1 : 0];
    always @(posedge clock) begin
        if (on) begin
            if (write_enable) begin
                mem[address] <= data_in;
            end 
            else begin
                data_out <= mem[address];
            end               
        end
        else begin
            data_out <= 0;
        end
    end    
endmodule

