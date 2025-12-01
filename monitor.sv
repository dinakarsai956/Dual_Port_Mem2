///////////////////////////////////////////////////////////////////////////
//  Monitor class recieves the inputs through interface and they are sending
// data to scoreboard class and reference class.
//////////////////////////////////////////////////////////////////////////

class monitor;
  virtual dual_port dp;
  mailbox #(transaction) mbx2refa;  // mailbox for reference 
  mailbox #(transaction) mbx2refb;
  mailbox #(transaction) mbx2sco;  // mailbox to scoreboard
  transaction tr;
  function new(virtual dual_port dp, mailbox#(transaction) mbx2refa, mailbox#(transaction) mbx2refb,
               mailbox#(transaction) mbx2sco);
    this.dp = dp;
    this.mbx2refa = mbx2refa;
    this.mbx2refb = mbx2refb;

    this.mbx2sco = mbx2sco;
  endfunction

  task run();
    tr = new();
    forever begin
      @(negedge dp.i_clk_a);
      tr.i_en_a   = dp.mon_cb_a.i_en_a;
      tr.i_we_a   = dp.mon_cb_a.i_we_a;
      tr.i_din_a  = dp.mon_cb_a.i_din_a;
      tr.i_addr_a = dp.mon_cb_a.i_addr_a;
      @(negedge dp.i_clk_b);
      tr.i_en_b   = dp.mon_cb_b.i_en_b;
      tr.i_we_b   = dp.mon_cb_b.i_we_b;
      tr.i_din_b  = dp.mon_cb_b.i_din_b;
      tr.i_addr_b = dp.mon_cb_b.i_addr_b;
      mbx2refa.put(tr);
      mbx2refb.put(tr);
      mbx2sco.put(tr);
      tr.display("MON");
    end
  endtask
endclass
