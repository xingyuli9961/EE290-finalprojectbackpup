// XINGYU: The main change here is to change the multiply to XNOR in PE Single
// weights and input activations should be only 1 bit
// Change all the input bitwidth accordingly to 1
//

// This is the blackbox we are asking you to implement
// Assume TILEROWS=1, and TILECOLUMNS=1
module MeshBlackBox
    #(parameter MESHROWS, MESHCOLUMNS, INPUT_BITWIDTH, OUTPUT_BITWIDTH, TILEROWS=1, TILECOLUMNS=1)
    (
        input                               clock,
        input                               reset,
        input signed                        in_a[MESHROWS-1:0][TILEROWS-1:0],
        input signed [INPUT_BITWIDTH-1:0]   in_d[MESHCOLUMNS-1:0][TILECOLUMNS-1:0],
        input signed                        in_b[MESHCOLUMNS-1:0][TILECOLUMNS-1:0],
        input                               in_control_dataflow[MESHCOLUMNS-1:0][TILECOLUMNS-1:0],
        input                               in_control_propagate[MESHCOLUMNS-1:0][TILECOLUMNS-1:0],
        input                               in_valid[MESHCOLUMNS-1:0][TILECOLUMNS-1:0],
        output signed [OUTPUT_BITWIDTH-1:0] out_c[MESHCOLUMNS-1:0][TILECOLUMNS-1:0],
        output signed [OUTPUT_BITWIDTH-1:0] out_b[MESHCOLUMNS-1:0][TILECOLUMNS-1:0],
        output                              out_valid[MESHCOLUMNS-1:0][TILECOLUMNS-1:0]
    );

    // ---------------------------------------------------------
    // ---------------------------------------------------------
    //           DO NOT MODIFY ANYTHING ABOVE THIS
    // ---------------------------------------------------------
    // ---------------------------------------------------------

    //**********************************************************
    //**********************************************************
    //**********************************************************
    //******************** FILL THIS ***************************
    //**********************************************************
    //**********************************************************
    //**********************************************************


    // Reshape the input towards the format to feed into the PE_Column_Helper,
    // to say, assume TILEROWS=1, TILECOLUMNS=1
    wire signed in_a_col [MESHROWS-1:0];
    wire signed in_b_row [MESHCOLUMNS-1:0];
    wire in_control_propagate_row [MESHCOLUMNS-1:0];
    wire in_valid_row [MESHCOLUMNS-1:0];
    // 2D array wires for forwarding input activations
    wire signed forward_a_twoD [MESHCOLUMNS-1:0][MESHROWS-1:0];

    // Reshape in_a
    genvar i;
    generate
        for (i = 0; i < MESHROWS; i += 1) begin
            assign in_a_col[i] = in_a[i][0];
        end
    endgenerate

    // Reshape in_b, in_control_propagate, and in_valid
    genvar j;
    generate
        for (j = 0; j < MESHCOLUMNS; j += 1) begin
            assign in_b_row[j] = in_b[j][0];
            assign in_control_propagate_row[j] = in_control_propagate[j][0];
            assign in_valid_row[j] = in_valid[j][0];
        end
    endgenerate
    // Instantiate the Mesh network with Column_Helper as Building blocks
    genvar k;
    generate
        for (k = 0; k < MESHCOLUMNS; k += 1) begin
            if (k == 0) begin
                PE_Column_Helper # (.MESHROWS(MESHROWS), .INPUT_BITWIDTH(INPUT_BITWIDTH), .OUTPUT_BITWIDTH(OUTPUT_BITWIDTH)) pe_col (
                    .clock(clock),
                    .reset(reset),
                    .col_in_a(in_a_col),
                    .col_in_b(in_b_row[k]),
                    .col_in_control_propagate(in_control_propagate_row[k]),
                    .col_in_valid(in_valid_row[k]),
                    .col_out_a(forward_a_twoD[k]),
                    .col_out_c(out_c[k][0]),
                    .col_out_valid(out_valid[k][0])
                );
            end else begin
                PE_Column_Helper # (.MESHROWS(MESHROWS), .INPUT_BITWIDTH(INPUT_BITWIDTH), .OUTPUT_BITWIDTH(OUTPUT_BITWIDTH)) pe_col (
                    .clock(clock),
                    .reset(reset),
                    .col_in_a(forward_a_twoD[k-1]),
                    .col_in_b(in_b_row[k]),
                    .col_in_control_propagate(in_control_propagate_row[k]),
                    .col_in_valid(in_valid_row[k]),
                    .col_out_a(forward_a_twoD[k]),
                    .col_out_c(out_c[k][0]),
                    .col_out_valid(out_valid[k][0])
                );
            end
        end
    endgenerate
endmodule // MeshBlackBox

//**********************************************************
//**********************************************************
//**********************************************************
//********** FEEL FREE TO ADD MODULES HERE *****************
//**********************************************************
//**********************************************************
//**********************************************************
module PE_Column_Helper // A Helper Module that builds a column of PE, so that the MeshBlackBox is not a mess and readable
    #(parameter MESHROWS, INPUT_BITWIDTH, OUTPUT_BITWIDTH)
    (
        input clock,
        input reset,
        input signed col_in_a [MESHROWS-1:0],  // input activations of all rows
        input signed col_in_b,  // weight
        input col_in_control_propagate,
        input col_in_valid,

        output signed col_out_a [MESHROWS-1:0],  // forward the input activations of all rows 
        output signed [OUTPUT_BITWIDTH-1:0] col_out_c, // the actual output 
        output col_out_valid
    );

    // wires for forwarding weights between registers
    wire signed forward_b [MESHROWS-1:0];
    // wires for forwarding partial sums
    wire signed [OUTPUT_BITWIDTH-1:0] forward_c [MESHROWS-1:0];
    // wires for forwarding propagate controls
    wire forward_propagate [MESHROWS-1:0];
    // wires for forwarding valid bits
    wire forward_valid [MESHROWS-1:0];

    // hardcode 0
    wire signed [OUTPUT_BITWIDTH-1:0] initialSum;
    assign initialSum = 0;

    // Instantiate a column of MESHROWS number of PE_Single's
    genvar i;
    generate
        for (i = 0; i < MESHROWS; i += 1) begin
            if (i == 0) begin
                // The fist/top PE of the colomn
                PE_Single #(.INPUT_BITWIDTH(INPUT_BITWIDTH), .OUTPUT_BITWIDTH(OUTPUT_BITWIDTH)) pe (
                    .clock(clock),
                    .reset(reset),
                    .pe_in_a(col_in_a[i]),
                    .pe_in_b(col_in_b),
                    .pe_in_psum(initialSum),
                    .pe_in_control_propagate(col_in_control_propagate),
                    .pe_in_valid(col_in_valid),
                    .pe_out_a(col_out_a[i]),
                    .pe_out_b(forward_b[i]),
                    .pe_out_c(forward_c[i]),
                    .pe_out_control_propagate(forward_propagate[i]),
                    .pe_out_valid(forward_valid[i]));
            end else if (i == MESHROWS - 1) begin
                // The last/bottom PE of the column
                PE_Single #(.INPUT_BITWIDTH(INPUT_BITWIDTH), .OUTPUT_BITWIDTH(OUTPUT_BITWIDTH)) pe (
                    .clock(clock),
                    .reset(reset),
                    .pe_in_a(col_in_a[i]),
                    .pe_in_b(forward_b[i-1]),
                    .pe_in_psum(forward_c[i-1]),
                    .pe_in_control_propagate(forward_propagate[i-1]),
                    .pe_in_valid(forward_valid[i-1]),
                    .pe_out_a(col_out_a[i]),
                    .pe_out_b(forward_b[i]),
                    .pe_out_c(col_out_c),
                    .pe_out_control_propagate(forward_propagate[i]),
                    .pe_out_valid(col_out_valid));
            end else begin
                // The PEs in the middle
                PE_Single #(.INPUT_BITWIDTH(INPUT_BITWIDTH), .OUTPUT_BITWIDTH(OUTPUT_BITWIDTH)) pe (
                    .clock(clock),
                    .reset(reset),
                    .pe_in_a(col_in_a[i]),
                    .pe_in_b(forward_b[i-1]),
                    .pe_in_psum(forward_c[i-1]),
                    .pe_in_control_propagate(forward_propagate[i-1]),
                    .pe_in_valid(forward_valid[i-1]),
                    .pe_out_a(col_out_a[i]),
                    .pe_out_b(forward_b[i]),
                    .pe_out_c(forward_c[i]),
                    .pe_out_control_propagate(forward_propagate[i]),
                    .pe_out_valid(forward_valid[i]));

            end
        end
    endgenerate

endmodule // PE_Column_Helper

// weights should be only 1 bit
module PE_Single  // A single PE
    #(parameter INPUT_BITWIDTH, OUTPUT_BITWIDTH)
    (
        input wire clock,
        input wire reset,
        input wire signed pe_in_a,  // input activation
        input wire signed pe_in_b,  // weight
        input wire signed [OUTPUT_BITWIDTH-1:0] pe_in_psum,  // partial sum
        input wire pe_in_control_propagate,
        input wire pe_in_valid,

        output reg signed pe_out_a,  // forward input activation
        output reg signed pe_out_b,  // forward the weight
        output reg signed [OUTPUT_BITWIDTH-1:0] pe_out_c,  // forward the partial sum
        output reg pe_out_control_propagate,  // forward propogration control
        output reg pe_out_valid  // forward input valid bit
    );
    // Double buffer for weights
    reg signed b_buffer[1:0];
    // Use the one not to propagate for multiplication
    wire signed b_to_compute = pe_in_control_propagate ? b_buffer[0] : b_buffer[1];

    always @(posedge clock) begin
        // reset everything to 0
        if (reset) begin
            pe_out_a <= 0;
            pe_out_b <= 0;
            pe_out_c <= 0;
            pe_out_control_propagate <= 0;
            pe_out_valid <= 0;
            b_buffer[0] <= 0;
            b_buffer[1] <= 0;
        end
        else begin
            // update the PE's inner state when the in_valid
            if (pe_in_valid) begin
                pe_out_control_propagate <= pe_in_control_propagate;
                // Propagate and update the buffer with the index the propagate signal directs
                if (pe_in_control_propagate) begin
                    b_buffer[1] <= pe_in_b;
                    pe_out_b <= b_buffer[1];
                end else begin
                    b_buffer[0] <= pe_in_b;
                    pe_out_b <= b_buffer[0];
                end
            end
            // calculate c = a * b + psum
            pe_out_c <=  b_to_compute^~pe_in_a ? pe_in_psum + 1: pe_in_psum - 1;
            // Forward input activation and valid bit
            pe_out_a <= pe_in_a;
            pe_out_valid <= pe_in_valid;
        end
    end

endmodule // PE_Single


// ---------------------------------------------------------
// ---------------------------------------------------------
//           DO NOT MODIFY ANYTHING BELOW THIS
// ---------------------------------------------------------
// ---------------------------------------------------------

// We are providing this adapter, due to the format of Chisel-generated Verilog
// and it's compatibility with a blackbox interface.
//
// This adapter converts the Gemmini multiplication function into something
// more amenable to teaching:
//
// Assumed that bias matrix is 0.
//
// Originally Gemmini does:
//   A*D + B => B
//   0 => C
//
// This adapter converts it to the following:
//   A*B + D => C
//   0 => B
module MeshBlackBoxAdapter
  #(parameter MESHROWS, MESHCOLUMNS, INPUT_BITWIDTH, OUTPUT_BITWIDTH, TILEROWS=1, TILECOLUMNS=1)
    (
    input                                                clock,
    input                                                reset,
    input [MESHROWS*TILEROWS-1:0]                        in_a,
    input [MESHCOLUMNS*TILECOLUMNS*INPUT_BITWIDTH-1:0]   in_d,
    input [MESHCOLUMNS*TILECOLUMNS-1:0]   in_b,
    input [MESHCOLUMNS*TILECOLUMNS-1:0]                  in_control_dataflow,
    input [MESHCOLUMNS*TILECOLUMNS-1:0]                  in_control_propagate,
    input [MESHCOLUMNS*TILECOLUMNS-1:0]                  in_valid,
    output [MESHCOLUMNS*TILECOLUMNS*OUTPUT_BITWIDTH-1:0] out_c,
    output [MESHCOLUMNS*TILECOLUMNS*OUTPUT_BITWIDTH-1:0] out_b,
    output [MESHCOLUMNS*TILECOLUMNS-1:0]                 out_valid
    );

  wire signed                       in_a_2d[MESHROWS-1:0][TILEROWS-1:0];
  wire signed [INPUT_BITWIDTH-1:0]  in_d_2d[MESHCOLUMNS-1:0][TILECOLUMNS-1:0];
  wire signed                       in_b_2d[MESHCOLUMNS-1:0][TILECOLUMNS-1:0];
  wire                              in_control_dataflow_2d[MESHCOLUMNS-1:0][TILECOLUMNS-1:0];
  wire                              in_control_propagate_2d[MESHCOLUMNS-1:0][TILECOLUMNS-1:0];
  wire                              in_valid_2d[MESHCOLUMNS-1:0][TILECOLUMNS-1:0];
  wire signed [OUTPUT_BITWIDTH-1:0] out_c_2d[MESHCOLUMNS-1:0][TILECOLUMNS-1:0];
  wire signed [OUTPUT_BITWIDTH-1:0] out_b_2d[MESHCOLUMNS-1:0][TILECOLUMNS-1:0];
  wire                              out_valid_2d[MESHCOLUMNS-1:0][TILECOLUMNS-1:0];
  reg signed [OUTPUT_BITWIDTH-1:0] reg_out_c_2d[MESHCOLUMNS-1:0][TILECOLUMNS-1:0];
  reg signed [OUTPUT_BITWIDTH-1:0] reg_out_b_2d[MESHCOLUMNS-1:0][TILECOLUMNS-1:0];
  reg                              reg_out_valid_2d[MESHCOLUMNS-1:0][TILECOLUMNS-1:0];

  // Convert wide signals into "cleaner" 2D Verilog arrays
  genvar i;
  genvar j;
  generate
  for (i = 0; i < MESHROWS ; i++) begin
    for (j = 0; j < TILEROWS ; j++) begin
      assign in_a_2d[i][j] = in_a[i*(TILEROWS)+j : i*(TILEROWS)+j];
    end
  end
  endgenerate

  generate
  for (i = 0; i < MESHCOLUMNS ; i++) begin
    for (j = 0; j < TILECOLUMNS ; j++) begin
       assign in_d_2d[i][j] = in_d[i*(TILECOLUMNS*INPUT_BITWIDTH)+(j+1)*(INPUT_BITWIDTH)-1:i*(TILECOLUMNS*INPUT_BITWIDTH)+j*(INPUT_BITWIDTH)];
       assign in_b_2d[i][j] = in_b[i*(TILECOLUMNS)+j : i*(TILECOLUMNS)+j];
       assign in_control_dataflow_2d[i][j] = in_control_dataflow[i*(TILECOLUMNS)+(j+1)-1:i*(TILECOLUMNS)+j];
       assign in_control_propagate_2d[i][j] = in_control_propagate[i*(TILECOLUMNS)+(j+1)-1:i*(TILECOLUMNS)+j];
       assign in_valid_2d[i][j] = in_valid[i*(TILECOLUMNS)+(j+1)-1:i*(TILECOLUMNS)+j];

       assign out_c[i*(TILECOLUMNS*OUTPUT_BITWIDTH)+(j+1)*(OUTPUT_BITWIDTH)-1:i*(TILECOLUMNS*OUTPUT_BITWIDTH)+j*(OUTPUT_BITWIDTH)] = reg_out_c_2d[i][j];
       assign out_b[i*(TILECOLUMNS*OUTPUT_BITWIDTH)+(j+1)*(OUTPUT_BITWIDTH)-1:i*(TILECOLUMNS*OUTPUT_BITWIDTH)+j*(OUTPUT_BITWIDTH)] = reg_out_b_2d[i][j];
       assign out_valid[i*(TILECOLUMNS)+(j+1)-1:i*(TILECOLUMNS)+j] = reg_out_valid_2d[i][j];

       always @(posedge clock) begin
           if (reset) begin
               // reset all values to 0
               reg_out_c_2d[i][j] <= '0;
               reg_out_b_2d[i][j] <= '0;
               reg_out_valid_2d[i][j] <= '0;
           end
           else begin
               // regnext the values
               reg_out_c_2d[i][j] <= out_c_2d[i][j];
               reg_out_b_2d[i][j] <= out_b_2d[i][j];
               reg_out_valid_2d[i][j] <= out_valid_2d[i][j];
           end
       end
    end
  end
  endgenerate

  // Instantiate the Mesh BlackBox implementation (the one you are writing in
  // this assignment)
  // Note: This swaps signals around a bit:
  //   in_b <-> in_d
  //   out_c <-> out_b
  MeshBlackBox #(.MESHROWS(MESHROWS),.TILEROWS(TILEROWS),.MESHCOLUMNS(MESHCOLUMNS),.TILECOLUMNS(TILECOLUMNS),.INPUT_BITWIDTH(INPUT_BITWIDTH),.OUTPUT_BITWIDTH(OUTPUT_BITWIDTH))
   mesh_blackbox_inst (
       .clock                (clock),
       .reset                (reset),
       .in_a                 (in_a_2d),
       .in_d                 (in_b_2d),
       .in_b                 (in_d_2d),
       .in_control_dataflow  (in_control_dataflow_2d),
       .in_control_propagate (in_control_propagate_2d),
       .in_valid             (in_valid_2d),
       .out_c                (out_b_2d),
       .out_b                (out_c_2d),
       .out_valid            (out_valid_2d)
  );

endmodule  //MeshBlackBoxAdapter
