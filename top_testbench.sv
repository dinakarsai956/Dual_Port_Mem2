/////////////////////////////////////////////////////////////////////////////////
// Creating of testbench for top module by including parameter widths and
// main_module by DUT instantition. 
//////////////////////////////////////////////////////////////////////////////////
`include "packet.sv"
`include "pkg.sv"
`include "dual_port_memory_top_module2.sv"
module top_testbench;
  environment env;
  dual_port dp ();
  parameter WIDTH = 8;
  parameter CODE_WIDTH = 12;
  parameter ADDR_WIDTH = 5;
  parameter WRITE_LATENCY_A = 4;
  parameter READ_LATENCY_A = 5;
  parameter WRITE_LATENCY_B = 4;
  parameter READ_LATENCY_B = 5;
  parameter NUM_BANK = 4;
  parameter DEPTH = 2 ** ADDR_WIDTH;
  dual_port_memory_top_module2 #(
      .WIDTH(WIDTH),
      .CODE_WIDTH(CODE_WIDTH),
      .ADDR_WIDTH(ADDR_WIDTH),
      .WRITE_LATENCY_A(WRITE_LATENCY_A),
      .READ_LATENCY_A(READ_LATENCY_A),
      .WRITE_LATENCY_B(WRITE_LATENCY_B),
      .READ_LATENCY_B(READ_LATENCY_B),
      .NUM_BANK(NUM_BANK),
      .DEPTH(DEPTH)
  ) dut (
      .i_clk_a(dp.i_clk_a),
      .i_clk_b(dp.i_clk_b),
      .i_en_a(dp.i_en_a),
      .i_en_b(dp.i_en_b),
      .i_we_a(dp.i_we_a),
      .i_we_b(dp.i_we_b),
      .i_din_a(dp.i_din_a),
      .i_din_b(dp.i_din_b),
      .i_addr_a(dp.i_addr_a),
      .i_addr_b(dp.i_addr_b),
      .o_dout_a1(dp.o_dout_a),
      .o_dout_b1(dp.o_dout_b)
  );
  initial begin
    dp.i_clk_a = 0;
    dp.i_clk_b = 0;
  end
  always #10 dp.i_clk_a = ~dp.i_clk_a;
  always #10 dp.i_clk_b = ~dp.i_clk_b;
  initial begin
    env = new(dp);
    env.main();
  end
  initial begin
    #5000 $finish;
  end
endmodule
