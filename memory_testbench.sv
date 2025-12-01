//////////////////////////////////////////////////////////////////////////
// Design of memory testbench by passing random inputs to i_din_a, i_din_b
// and i_addr_a, i_addr_b  testing by passing various inputs for memory
// whether it is working for write and read by passing i_en_a , i_en_b 
// i_we_a , i_we_b and to write and read.
//
/////////////////////////////////////////////////////////////////////////



module memory_test_bench;
  parameter WIDTH = 8;
  parameter ADDR = 3;
  parameter DEPTH = 2 ** ADDR;
  reg i_clk_a, i_clk_b;
  reg i_en_a, i_en_b;
  reg i_we_a, i_we_b;
  reg [WIDTH-1:0] i_din_a, i_din_b;
  reg [ADDR-1:0] i_addr_a, i_addr_b;
  reg [WIDTH-1:0] o_dout_a, o_dout_b;
  memory #(
      .WIDTH(WIDTH),
      .ADDR (ADDR),
      .DEPTH(DEPTH)
  ) dut (
      .i_clk_a (i_clk_a),
      .i_clk_b (i_clk_b),
      .i_en_a  (i_en_a),
      .i_en_b  (i_en_b),
      .i_we_a  (i_we_a),
      .i_we_b  (i_we_b),
      .i_addr_a(i_addr_a),
      .i_addr_b(i_addr_b),
      .i_din_a (i_din_a),
      .i_din_b (i_din_b),
      .o_dout_a(o_dout_a),
      .o_dout_b(o_dout_b)
  );
  initial begin
    i_clk_a = 0;
    i_clk_b = 0;
    i_en_a  = 0;
    i_en_b  = 0;
    i_we_a  = 0;
    i_we_b  = 0;
  end
  always #5 i_clk_a = ~i_clk_a;
  always #10 i_clk_b = ~i_clk_b;
  initial begin
    forever begin
      i_din_a  = $random;
      i_addr_a = $urandom_range(0, 3);
      @(negedge i_clk_a);
      i_din_b  = $random;
      i_addr_b = $urandom_range(4, 7);
      @(negedge i_clk_b);
    end
  end
  initial begin
    forever begin
      i_en_a = 0;
      i_we_a = 1;
      @(negedge i_clk_a);
      i_en_a = 1;
      i_we_a = 1;
      @(negedge i_clk_a);
      i_we_a = 0;
      @(negedge i_clk_a);
      i_we_a = 1;
      @(negedge i_clk_a);
      i_en_a = 0;
      @(negedge i_clk_a);
      i_en_a = 1;
      i_we_a = 0;
      @(negedge i_clk_a);
    end
  end
  initial begin
    forever begin
      i_en_b = 0;
      i_we_b = 1;
      @(negedge i_clk_b);
      i_en_b = 1;
      i_we_b = 1;
      @(negedge i_clk_b);
      i_we_b = 0;
      @(negedge i_clk_b);
      i_en_b = 0;
      @(negedge i_clk_b);
      i_en_b = 1;
      i_we_b = 0;
      @(negedge i_clk_b);
    end
  end
  initial begin
    #2000 $finish;
  end
endmodule
