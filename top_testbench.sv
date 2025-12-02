/////////////////////////////////////////////////////////////////////////////////
// Creating of testbench for top module by including parameter widths and
// main_module by DUT instantition. 
//////////////////////////////////////////////////////////////////////////////////
//`include "packet.sv"
`include "interface.sv"
`include "pkg.sv"
import dual_port::*;

`include "dual_port_memory_top_module2.sv"
module top_testbench;
  test t;
  dual_port_vif dp_vif ();
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
      .i_clk_a(dp_vif.i_clk_a),
      .i_clk_b(dp_vif.i_clk_b),
      .i_en_a(dp_vif.i_en_a),
      .i_en_b(dp_vif.i_en_b),
      .i_we_a(dp_vif.i_we_a),
      .i_we_b(dp_vif.i_we_b),
      .i_din_a(dp_vif.i_din_a),
      .i_din_b(dp_vif.i_din_b),
      .i_addr_a(dp_vif.i_addr_a),
      .i_addr_b(dp_vif.i_addr_b),
      .o_dout_a1(dp_vif.o_dout_a),
      .o_dout_b1(dp_vif.o_dout_b)
  );
  initial begin
    dp_vif.i_clk_a = 0;
    dp_vif.i_clk_b = 0;
  end
  initial begin
    fork
      forever #5 dp_vif.i_clk_a = ~dp_vif.i_clk_a;  // clock designing at time period of 5ns
      forever #10 dp_vif.i_clk_b = ~dp_vif.i_clk_b;  // clock designing at time period of 10ns
      begin
        t = new(dp_vif);
        t.main();
      end
    join_none
  end
  initial begin
    wait (t.env.sco.sco_done.triggered);
    $display("Generated 50 transactions");
    #10;
    disable fork;
    $finish;
  end

endmodule
