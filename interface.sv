//////////////////////////////////////////////////////////////////////////////////////////
//
// Creating interface where interface bundles all signals inputs and outputs.
// Here we are creating interface for dual port memory 
/////////////////////////////////////////////////////////////////////////////////////////

interface dual_port_vif #(
    parameter WIDTH = 12,
    parameter ADDR_WIDTH = 10
);

  logic i_clk_a, i_clk_b;
  logic i_we_a, i_we_b;
  logic i_en_a, i_en_b;
  logic [WIDTH-1:0] i_din_a, i_din_b;
  logic [ADDR_WIDTH-1:0] i_addr_a, i_addr_b;
  logic [WIDTH-1:0] o_dout_a, o_dout_b;


  clocking drv_cb_a @(posedge i_clk_a);
    output i_en_a, i_we_a, i_din_a, i_addr_a;
    input o_dout_a;
  endclocking

  clocking drv_cb_b @(posedge i_clk_b);
    output i_en_b, i_we_b, i_din_b, i_addr_b;
    input o_dout_b;
  endclocking


  clocking mon_cb_a @(posedge i_clk_a);
    input i_en_a, i_we_a, i_din_a, i_addr_a;
    input o_dout_a;
  endclocking

  clocking mon_cb_b @(posedge i_clk_b);
    input i_en_b, i_we_b, i_din_b, i_addr_b;
    input o_dout_b;
  endclocking

endinterface

