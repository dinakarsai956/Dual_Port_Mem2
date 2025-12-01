////////////////////////////////////////////////////////////////////////////
//  Generator class will generate the inputs by creating object from
//  transaction class . By using a mailbox we are sending transaction to
//  driver class by using put method .
//
///////////////////////////////////////////////////////////////////////////

class generator;
  transaction t;
  mailbox #(transaction) gen2drv;  // mailbox for using transactions from one class to another
  int num_transactions = 50;
  function new(mailbox#(transaction) gen2drv);
    this.gen2drv = gen2drv;
  endfunction

  task run();
    repeat (num_transactions) begin
      t = new();
      if (!t.randomize()) begin
        $display("[GEN] Randomization Failed");
      end
      t.display("GEN");

      gen2drv.put(t);
    end
    $display("[GEN] number of transactions ", num_transactions);
  endtask
endclass
