///////////////////////////////////////////////////////////////////////////
//  Monitor class recieves the inputs through interface and they are sending
// data to scoreboard class and reference class.
//////////////////////////////////////////////////////////////////////////
`ifndef MONITOR_A_SV
;
`define MONITOR_A_SV ;
class monitor_a;
  virtual dual_port_vif dp_vif;
  mailbox #(transaction) mon2refa;  // mailbox for reference 
  //  mailbox #(transaction) mbx2refb;
  mailbox #(transaction) mon2scoa;  // mailbox to scoreboard
  transaction tr;
  function new(virtual dual_port_vif dp_vif, mailbox#(transaction) mon2refa,
               mailbox#(transaction) mon2scoa);
    this.dp_vif   = dp_vif;
    this.mon2refa = mon2refa;
    this.mon2scoa = mon2scoa;
  endfunction

  task run();
    tr = new();
    forever begin
      @(negedge dp_vif.i_clk_a);
      tr.i_en_a   = dp_vif.mon_cb_a.i_en_a;
      tr.i_we_a   = dp_vif.mon_cb_a.i_we_a;
      tr.i_din_a  = dp_vif.mon_cb_a.i_din_a;
      tr.i_addr_a = dp_vif.mon_cb_a.i_addr_a;
      mon2refa.put(tr);
      mon2scoa.put(tr);
      tr.display("MON_A");
    end
  endtask
endclass
`endif
