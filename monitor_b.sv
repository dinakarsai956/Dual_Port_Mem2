///////////////////////////////////////////////////////////////////////////
//  Monitor class recieves the inputs through interface and they are sending
// data to scoreboard class and reference class.
//////////////////////////////////////////////////////////////////////////
`ifndef MONITOR_B_SV
`define MONITOR_B_SV
class monitor_b;
  virtual dual_port_vif dp_vif;
  mailbox #(transaction) mon2refb;  // mailbox for reference 
  // mailbox #(transaction) mon2refb;
  mailbox #(transaction) mon2scob;  // mailbox to scoreboard
  transaction tr;
  function new(virtual dual_port_vif dp_vif, mailbox#(transaction) mon2refb,
               mailbox#(transaction) mon2scob);
    this.dp_vif   = dp_vif;
    this.mon2refb = mon2refb;
    //this.mbx2refb = mbx2refb;

    this.mon2scob = mon2scob;
  endfunction

  task run();
    tr = new();
    forever begin
      @(negedge dp_vif.i_clk_b);
      tr.i_en_b   = dp_vif.mon_cb_b.i_en_b;
      tr.i_we_b   = dp_vif.mon_cb_b.i_we_b;
      tr.i_din_b  = dp_vif.mon_cb_b.i_din_b;
      tr.i_addr_b = dp_vif.mon_cb_b.i_addr_b;

      mon2refb.put(tr);
      //mbx2refb.put(tr);
      mon2scob.put(tr);
      tr.display("MON_B");
    end
  endtask
endclass
`endif
