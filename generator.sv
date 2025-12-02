////////////////////////////////////////////////////////////////////////////
//  Generator class will generate the inputs by creating object from
//  transaction class . By using a mailbox we are sending transaction to
//  driver class by using put method .
//
///////////////////////////////////////////////////////////////////////////
`ifndef GENERATOR_SV
`define GENERATOR_SV
class generator;
  transaction t;
  mailbox #(transaction)
      gen2drv_a, gen2drv_b;  // mailboxes for using transactions from one class to another
  //  int count = 0;
  int num_transactions = 50;
  // event gen_done;
  function new(mailbox#(transaction) gen2drv_a, gen2drv_b);
    this.gen2drv_a = gen2drv_a;
    this.gen2drv_b = gen2drv_b;
  endfunction

  task run();
    repeat (num_transactions) begin
      t = new();
      if (!t.randomize()) begin
        $display("[GEN] Randomization Failed");
      end
      t.display("GEN");

      gen2drv_a.put(t);
      gen2drv_b.put(t);
    end
  endtask
endclass
`endif
