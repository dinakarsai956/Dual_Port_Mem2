///////////////////////////////////////////////////////////////////////
// Here we are driving inputs for Port_B by using mailboxes by getting 
// generated data from generator and driving at negedge of the i_clk_b
/////////////////////////////////////////////////////////////////////

`ifndef DRIVER_B_SV
`define DRIVER_B_SV
class driver_b;
  // Mailbox from generator to driver
  mailbox #(transaction) gen2drv_b;
  virtual dual_port_vif  dp_vif;
  // Constructor: keep parameter order consistent with the member above.
  function new(mailbox#(transaction) gen2drv_b, virtual dual_port_vif dp_vif);
    this.gen2drv_b = gen2drv_b;
    this.dp_vif    = dp_vif;
  endfunction

  // Optional: initial defaults (can be moved to run())
  task init_defaults();
    // Drive safe defaults before starting
    dp_vif.i_en_b   <= 1'b0;
    dp_vif.i_we_b   <= 1'b0;
    dp_vif.i_addr_b <= '0;
    dp_vif.i_din_b  <= '0;
  endtask

  task run();
    transaction t;

    // Initialize outputs once
    init_defaults();

    forever begin
      // Block until we receive the next item
      gen2drv_b.get(t);
      dp_vif.i_en_b   <= t.i_en_b;
      dp_vif.i_we_b   <= t.i_we_b;
      dp_vif.i_din_b  <= t.i_din_b;
      dp_vif.i_addr_b <= t.i_addr_b;
      @(negedge dp_vif.i_clk_b);
    end
  endtask
endclass
`endif
