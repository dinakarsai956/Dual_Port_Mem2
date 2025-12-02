//////////////////////////////////////////////////////////////////////
//  Design of dual port memory latency testbench by parameters latency
// WRITE_LATENCY_A, READ_LATENCY_A, WRITE_LATENCY_B, READ_LATENCY_B,
// by delaying the signal for write and read by delaying the signal.
// //////////////////////////////////////////////////////////////////



module dual_port_memory_latency_testbench;

  parameter WIDTH = 8;
  parameter ADDR_WIDTH = 3;
  parameter WRITE_LATENCY_A = 4;
  parameter READ_LATENCY_A = 5;
  parameter WRITE_LATENCY_B = 4;
  parameter READ_LATENCY_B = 5;
  parameter DEPTH = 2 ** ADDR_WIDTH;

  logic i_clk_a = 0, i_clk_b = 0;
  logic i_en_a, i_en_b;
  logic i_we_a, i_we_b;
  logic [WIDTH-1:0] i_din_a, i_din_b;
  logic [ADDR_WIDTH-1:0] i_addr_a, i_addr_b;
  logic [WIDTH-1:0] o_dout_a, o_dout_b;

  dual_port_memory_latency #(
      .WIDTH(WIDTH),
      .ADDR_WIDTH(ADDR_WIDTH),
      .WRITE_LATENCY_A(WRITE_LATENCY_A),
      .READ_LATENCY_A(READ_LATENCY_A),
      .WRITE_LATENCY_B(WRITE_LATENCY_B),
      .READ_LATENCY_B(READ_LATENCY_B),
      .DEPTH(DEPTH)
  ) dut (
      .i_clk_a (i_clk_a),
      .i_clk_b (i_clk_b),
      .i_en_a  (i_en_a),
      .i_en_b  (i_en_b),
      .i_we_a  (i_we_a),
      .i_we_b  (i_we_b),
      .i_din_a (i_din_a),
      .i_din_b (i_din_b),
      .i_addr_a(i_addr_a),
      .i_addr_b(i_addr_b),
      .o_dout_a(o_dout_a),
      .o_dout_b(o_dout_b)
  );

  // Generate clocks
  always #10 i_clk_a = ~i_clk_a;  // 100 MHz
  always #10 i_clk_b = ~i_clk_b;  // ~71 MHz
  initial begin
    i_en_a = 0;
    i_we_a = 1;
    @(posedge i_clk_a);
    i_en_a   = 1;
    i_we_a   = 1;
    i_din_a  = 8'd12;
    i_addr_a = 3'd0;
    @(posedge i_clk_a);
    i_we_a   = 1;
    i_din_a  = 8'd13;
    i_addr_a = 3'd1;
    @(posedge i_clk_a);
    i_we_a   = 0;
    i_addr_a = 3'd0;
    @(posedge i_clk_a);
    i_addr_a = 3'd1;
    @(posedge i_clk_a);
    i_addr_a = 3'd0;
  end

  initial begin
    i_en_b = 0;
    i_we_b = 1;
    @(posedge i_clk_b);
    i_en_b   = 1;
    i_we_b   = 1;
    i_din_b  = 8'd09;
    i_addr_b = 3'd2;
    @(posedge i_clk_b);
    i_we_b   = 1;
    i_din_b  = 8'd08;
    i_addr_b = 3'd3;
    @(posedge i_clk_b);
    i_we_b   = 0;

    i_addr_b = 3'd2;
    @(posedge i_clk_b);
    i_addr_b = 3'd3;
    @(posedge i_clk_b);
    i_addr_b = 3'd2;
  end

  initial begin
    #400 $finish;
  end
endmodule
