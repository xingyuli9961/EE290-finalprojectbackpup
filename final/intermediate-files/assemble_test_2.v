module assemble_test();
  parameter NUMHELPER = 8;
  parameter INPUT_BITWIDTH = 25;
  parameter OUTPUT_BITWIDTH = 6;
  parameter SIZE = 32;
  
  reg clk;
  initial begin
    clk = 1'b0;
  end
  always #(5) clk <= ~clk;
  
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
  
  reg reset;
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
  
  assign in_a = data_out_input;
  assign in_b = data_out_weight;
  assign data_in_output = out_c;
  
  integer i, j, k;
  integer seed;
  reg [NUMHELPER*INPUT_BITWIDTH-1:0] copy_input [SIZE-1:0];
  reg [NUMHELPER*INPUT_BITWIDTH-1:0] copy_weight [SIZE-1:0];
  reg [OUTPUT_BITWIDTH*NUMHELPER-1:0] copy_output [SIZE-1:0];
  
  reg [23:0] result;
  reg [5:0] tmp [3:0];
  
  
  
  initial begin 
    $dumpfile("assemble.vcd");
    $dumpvars(0, scratchpad_input);
    $dumpvars(0, scratchpad_weight);
    $dumpvars(0, scratchpad_output);
    $dumpvars(0, accelerator);
    
    $display("Test starts!");
    
    
    result = 0;
   
    
    on_input = 1'b0;
    on_weight = 1'b0;
    on_output = 1'b0;
    reset = 1'b1;
    
    repeat (2) @(posedge clk);
    on_weight = 1'b1;
    address_weight = 0;
    write_enable_weight = 1'b1;
    $display("Start loading scratchpad for weight:");
    for (i = 0; i < SIZE; i = i + 1) begin
      seed = i+1;
      data_in_weight[31:0] = $urandom(seed);
      data_in_weight[63:32] = $urandom(seed);
      data_in_weight[95:64] = $urandom(seed);
      data_in_weight[99:96] = $urandom(seed);
      copy_weight[i] = data_in_weight;
      @(posedge clk);
      address_weight = address_weight + 'b01;
    end
    write_enable_weight = 1'b0;
    @(posedge clk);
    on_weight = 1'b0;
    @(posedge clk);
    
    on_input = 1'b1;
    address_input = 0;
    write_enable_input = 1'b1;
    $display("Start loading scratchpad for input:");
    for (i = 0; i < SIZE; i = i + 1) begin
      seed = i+100;
      data_in_input[31:0] = $urandom(seed);
      data_in_input[63:32] = $urandom(seed);
      data_in_input[95:64] = $urandom(seed);
      data_in_input[99:96] = $urandom(seed);
      copy_input[i] = data_in_input;
      @(posedge clk);
      address_input = address_input + 'b01;
    end
    write_enable_input = 1'b0;
    @(posedge clk);
    on_input = 1'b0;
    @(posedge clk);
    @(posedge clk);
    
    
    $display("Start the accelerator:");
    reset = 1'b0;
    address_input = 0;
    address_weight = 0;
    write_enable_output = 0;
    on_input = 1'b1;
    on_weight = 1'b1;
    on_output = 1'b1;
    @(posedge clk);
    for (i = 0; i < SIZE; i = i + 1) begin
      if (in_a != copy_input[address_input]) begin
        $display("Fail at address: %b, expected weight:%b, but get: %b", address_input, copy_input[address_input], in_a);
      end
      if (in_b != copy_weight[address_weight]) begin
        $display("Fail at address: %b, expected weight:%b, but get: %b", address_weight, copy_weight[address_weight], in_b);
      end
      
      for (j = 0; j < NUMHELPER; j = j + 1) begin
        tmp[j] = 0;
        for (k = 0; k < 25; k = k + 1) begin
          tmp[j] = in_a[j*25+k]^~in_b[j*25+k] ? tmp[j] + 1 : tmp[j] -1;
        end
      end
      result[5:0] = tmp[0];
      result[11:6] = tmp[1];
      result[17:12] = tmp[2];
      result[23:18] = tmp[3];
      copy_output[i] = result;
      
      address_input = address_input + 'b01;
      address_weight = address_weight + 'b01;
      if (j >= SIZE - 1) begin
        on_input = 1'b0;
        on_weight = 1'b0;
      end
      @(posedge clk);
      
      if (result != out_c) begin
        $display("Fails: Expected: %b, but get: %b", result, out_c);
      end
      write_enable_output = 1'b1;
      address_output = j >= SIZE - 1 ? SIZE -1 : address_input - 'b01;
    end
    @(posedge clk);
    write_enable_output = 1'b0;    
    $display("Finish loading outputs");
    @(posedge clk);
    @(posedge clk);
    address_output = 0;
    for (i = 0; i < SIZE; i = i + 1) begin
      @(posedge clk);
      if (data_out_output != copy_output[i]) begin
        $display("Fail!");
        $display("address: %d, expected: %d, actual: %d", address_output, copy_output[i], data_out_output);
      end
      address_output = address_output + 'b01;
    end
    
    $display("test finishes");
    $finish();
    
  end
    
  
endmodule

