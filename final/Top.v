/*
 I assembly the scratch pad with the accelerator at this level
 */

module Top
    #(parameter NUMHELPER = 4, INPUT_BITWIDTH=25, OUTPUT_BITWIDTH=6, SIZE=16)
    (
        input wire clock,
        input reset,
        input we_input,
        input we_weight,
        input start,
        input [$clog2(SIZE)-1 : 0] address_finish,
        input [$clog2(SIZE)-1 : 0] address_input,
        input [$clog2(SIZE)-1 : 0] address_weight,
        input [NUMHELPER*INPUT_BITWIDTH-1:0] data_weight,
        input [NUMHELPER*INPUT_BITWIDTH-1:0] data_input,

        output [NUMHELPER*OUTPUT_BITWIDTH-1:0] data_out
    );
    reg clk;
    integer i;
    reg acc_working;

    reg on_input;
    reg write_enable_input;
    reg [$clog2(SIZE)-1 : 0] address_input;
    reg [NUMHELPER*INPUT_BITWIDTH-1:0] data_in_input;
    wire [NUMHELPER*INPUT_BITWIDTH-1:0] data_out_input;
     scratchpad #(.NUMHELPER(NUMHELPER), .BITWIDTH(INPUT_BITWIDTH), .SIZE(SIZE)) scratchpad_input (
        .clock(clk),
        .on(on_input),
        .write_enable(write_enable_input),
        .address(address_input),
        .data_in(data_in_input),
        .data_out(data_out_input)
    );

    reg on_weight;
    reg write_enable_weight;
    reg [$clog2(SIZE)-1 : 0] address_weight;
    reg [NUMHELPER*INPUT_BITWIDTH-1:0] data_in_weight;
    wire [NUMHELPER*INPUT_BITWIDTH-1:0] data_out_weight;
    scratchpad #(.NUMHELPER(NUMHELPER), .BITWIDTH(INPUT_BITWIDTH), .SIZE(SIZE)) scratchpad_weight (
        .clock(clk),
        .on(on_weight),
        .write_enable(write_enable_weight),
        .address(address_weight),
        .data_in(data_in_weight),
        .data_out(data_out_weight)
    );

    reg on_output;
    reg write_enable_output;
    reg [$clog2(SIZE)-1 : 0] address_output;
    reg [NUMHELPER*OUTPUT_BITWIDTH-1:0] data_in_output;
    wire [NUMHELPER*OUTPUT_BITWIDTH-1:0] data_out_output;
    scratchpad #(.NUMHELPER(NUMHELPER), .BITWIDTH(OUTPUT_BITWIDTH), .SIZE(SIZE)) scratchpad_output (
        .clock(clk),
        .on(on_output),
        .write_enable(write_enable_output),
        .address(address_output),
        .data_in(data_in_output),
        .data_out(data_out_output)
    );

    reg [INPUT_BITWIDTH*NUMHELPER-1:0] in_a;
    reg [INPUT_BITWIDTH*NUMHELPER-1:0] in_b;
    wire [OUTPUT_BITWIDTH*NUMHELPER-1:0] out_c;
    XNORconvBlackBox #(.NUMHELPER(NUMHELPER), .INPUT_BITWIDTH(INPUT_BITWIDTH), .OUTPUT_BITWIDTH(OUTPUT_BITWIDTH)) accelerator (
        .clock(clk),
        .reset(reset),
        .pe_in_a(in_a),
        .pe_in_b(in_b),
        .pe_out_c(out_c)
    );

    reg [$clog2(SIZE)-1 : 0] end_address;
    reg stop_flag;

    assign in_a = data_out_input;
    assign in_b = data_out_weight;
    assign data_in_output = out_c;
    assign data_out = data_out_output;

    always @(posedge clock) begin
        if (reset) begin
            on_input <= 1'b0;
            on_weight <= 1'b0;
            on_output <= 1'b0;
            acc_working < = 1'b0;
            end_address <= 'b0;
            stop_flag <= 1'b0;
            finish <= 1'b0;
        end
        else begin
            if (we_input) begin
                on_input <= 1'b1;
                write_enable_input <= 1'b1;
                data_in_input <= data_input;
                address_input <= address_input; 
            end
            else if (acc_working) begin
                on_input <= 1'b1;
                write_enable_input <= 1'b0; 
            end 
            else
                on_input <= 1'b0;
                write_enable_input <= 1'b0;
            end
            if (we_weight) begin
                on_weight <= 1'b1;
                write_enable_weight <= 1'b1;
                data_in_weight <= data_weight;
                address_weight <= address_weight;
            end
            else if (acc_working) begin
                on_weight <= 1'b1;
                write_enable_weight <= 1'b0;
            end
            else
                on_input <= 1'b0;
                write_enable_weight <= 1'b0;
            end


        end
    end
    always @(posedge clock) begin
        if (start) begin
            acc_working <= 1'b1;
            on_output <= 1'b1;
            end_address <= address_finish;
            address_input <= 0;
            address_weight <= 0;
            finish <= 1'b0;
        end
        else if (stop_flag) begin
            on_output <= 1'b0;
            stop_flag <= 1'b1;
            finish <= 1'b1;
        end 
        else begin
            address_output <= address_input; 
            address_input <= address_input + 'b01;
            address_weight <= address_weight + 'b01;
            if (address_input >= end_address) begin
                on_input <= 1'b0;
                on_weight <= 1'b0;
                stop_flag <= 1'b1;
            end
        end
    end

endmodule
