/////////////////////////////////////////////////////////////////////////////////
// In environment class we created a custom constructor by using mailboxes for
// generator, driver, scoreboard, reference and interface . Here by using task
// method we are calling every class by object handle.
//
////////////////////////////////////////////////////////////////////////////////
`ifndef ENVIRONMENT_SV
`define ENVIRONMENT_SV
class environment;

  // --------------------------
  // Virtual interface
  // --------------------------
  virtual dual_port_vif dp_vif;

  // --------------------------
  // Mailboxes
  // --------------------------
  mailbox #(transaction) gen2drva_mbx;
  mailbox #(transaction) gen2drvb_mbx;
  mailbox #(transaction) mon2scoa_mbx;
  mailbox #(transaction) mon2scob_mbx;
  mailbox #(transaction) mon2refA_mbx;
  mailbox #(transaction) mon2refB_mbx;
  mailbox #(transaction) ref2sco_mbx;

  // --------------------------
  // Components
  // --------------------------
  generator gen;
  driver_a drv_a;
  driver_b drv_b;
  monitor_a mon_a;
  monitor_b mon_b;
  reference refe;
  scoreboard sco;

  // --------------------------
  // Constructor
  // --------------------------
  function new(virtual dual_port_vif dp_vif);
    this.dp_vif = dp_vif;

    // Create mailboxes
    gen2drva_mbx = new();
    gen2drvb_mbx = new();
    mon2scoa_mbx = new();
    mon2scob_mbx = new();
    mon2refA_mbx = new();
    mon2refB_mbx = new();
    ref2sco_mbx = new();

    // Instantiate components
    gen = new(gen2drva_mbx, gen2drvb_mbx);
    drv_a = new(gen2drva_mbx, dp_vif);
    drv_b = new(gen2drvb_mbx, dp_vif);
    mon_a = new(dp_vif, mon2scoa_mbx, mon2refA_mbx);
    mon_b = new(dp_vif, mon2scob_mbx, mon2refB_mbx);
    refe = new(mon2refA_mbx, mon2refB_mbx, ref2sco_mbx);
    sco = new(ref2sco_mbx, mon2scoa_mbx, mon2scob_mbx);
  endfunction

  // --------------------------
  // Run all components
  // --------------------------
  task main();
    fork
      gen.run();
      drv_a.run();
      drv_b.run();
      mon_a.run();
      mon_b.run();
      refe.portA();
      refe.portB();
      sco.main();
    join_none
  endtask

endclass
`endif
