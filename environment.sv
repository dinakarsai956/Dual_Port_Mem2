/////////////////////////////////////////////////////////////////////////////////
// In environment class we created a custom constructor by using mailboxes for
// generator, driver, scoreboard, reference and interface . Here by using task
// method we are calling every class by object handle.
//
////////////////////////////////////////////////////////////////////////////////

class environment;

  // --------------------------
  // Virtual interface
  // --------------------------
  virtual dual_port      dp;

  // --------------------------
  // Mailboxes
  // --------------------------
  mailbox #(transaction) gen2drv_mbx;
  mailbox #(transaction) mon2sco_mbx;
  mailbox #(transaction) mon2refA_mbx;
  mailbox #(transaction) mon2refB_mbx;
  mailbox #(transaction) ref2sco_mbx;

  // --------------------------
  // Components
  // --------------------------
  generator              gen;
  driver                 drv;
  monitor                mon;
  reference              refe;
  scoreboard             sco;

  // --------------------------
  // Constructor
  // --------------------------
  function new(virtual dual_port dp);

    this.dp = dp;

    // Created mailboxes
    gen2drv_mbx = new();
    mon2sco_mbx = new();
    mon2refA_mbx = new();
    mon2refB_mbx = new();
    ref2sco_mbx = new();


    gen = new(gen2drv_mbx);
    drv = new(gen2drv_mbx, dp);
    mon = new(dp, mon2sco_mbx, mon2refA_mbx, mon2refB_mbx);
    refe = new(mon2refA_mbx, mon2refB_mbx, ref2sco_mbx);
    sco = new(ref2sco_mbx, mon2sco_mbx);

  endfunction : new

  // --------------------------
  // Run all components
  // --------------------------
  task main();
    fork
      gen.run();
      drv.run();
      mon.run();
      refe.portA();
      refe.portB();
      sco.main();
    join_none
  endtask

endclass

