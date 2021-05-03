/*
 This is the unit test for the scratchpad.
 */

module Scratchpad_test();
    reg clk, on, write_enable;
    reg [4:0] address;
    reg [99:0] data_in;
    wire [99:0] data_out;

    initial begin
        clk = 1'b0;
    end
    always #(200) clk <= ~clk;

    scratchpad #(.NUMHELPER(4), .BITWIDTH(25), .SIZE(32)) dut (
        .clock(clk),
        .on(on),
        .write_enable(write_enable),
        .address(address),
        .data_in(data_in),
        .data_out(data_out)
    );
    reg [99:0] result [31:0];
    integer seed;
    integer i;

    initial begin
        $dumpfile("scratchpad.vcd");
        $dumpvars(0, dut);
        on = 1'b0;
        repeat (2) @(posedge clk);
        on = 1'b1;
        address = 5'b0;
        write_enable = 1'b1;
        $display("test starts");


      @(posedge clk);
      data_in = 0;
      address = 0;
      @(posedge clk);
      data_in = 1;
      address = 1;
      @(posedge clk);
      data_in = 2;
      address = 2;
      @(posedge clk);     
      data_in = 3;
      address = 3;
      @(posedge clk);
      data_in = 4;
      address = 4;
      @(posedge clk);
      data_in = 5;
      address = 5;
      @(posedge clk);      
      data_in = 6;
      address = 6;
      @(posedge clk);
      @(posedge clk);
      on = 1'b0;
      @(posedge clk);
      on = 1'b1;
      write_enable = 1'b0;
      @(posedge clk);
      address = 0;
      @(posedge clk);
      address = 1;
      @(posedge clk);
      address = 2;
      @(posedge clk);      
      address = 3;
      @(posedge clk);      
      address = 4;
      @(posedge clk);
      address = 5;
      @(posedge clk);      
      address = 6;
      @(posedge clk);



//        for (i = 0; i < 13; i = i + 1) begin
  //          seed = i+1;
            //data_in[31:0] = $urandom(seed);
            //data_in[63:32] = $urandom(seed);
            //data_in[95:64] = $urandom(seed);
            //data_in[99:96] = $urandom(seed);
    //        data_in = address;
      //      result[address] = data_in;
        //    @(posedge clk);
          //  $display("address: %d, expected: %d, input: %d", address, result[i], data_in);
           // address = address + 5'b01;
        //end
       // write_enable = 1'b0;
        //repeat (10) @(posedge clk);
        //on = 1'b0;
        //@(posedge clk);
        //on = 1'b1;
        //address = 5'b0;
        //for (i = 0; i < 13; i = i + 1) begin
          //  @(posedge clk);
            //$display("address: %d, expected: %d, actual: %d", address, result[i], data_out);
            //address = address + 5'b01;
        // end

    
        $finish();
    end


endmodule

