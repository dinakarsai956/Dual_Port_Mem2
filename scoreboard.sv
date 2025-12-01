//////////////////////////////////////////////////////////////////////////////////////////////
// Scoreboard is nothing but to compare the actual output and refernce output
// it will get the output by using mailbox from monitor class and reference
// class .
////////////////////////////////////////////////////////////////////////////////////////////////

class scoreboard;
  mailbox #(transaction) ref2sco;  // to get from reference to scoreboard
  mailbox #(transaction) mon2sco;  // to get from monitor to scoreboard
  transaction tr1;
  transaction tr2;
  int pass = 0;
  int fail = 0;
  function new(mailbox#(transaction) ref2sco, mailbox#(transaction) mon2sco);
    this.ref2sco = ref2sco;
    this.ref2sco = mon2sco;
  endfunction
  task main();
    tr1 = new();
    tr2 = new();
    forever begin
      ref2sco.get(tr1);
      mon2sco.get(tr2);
      // PORT_A
      if (!tr1.i_we_a) begin
        if ((tr1.i_din_a == tr2.o_dout_a) && (tr1.error_a == tr2.error_a)) begin
          pass++;
          $display(
              $time,
              "[SCO] addr_a = %0d \t din_a = %0d \t dout_a = %0d \t  error_a = %0d \t error_a = %0d",
              tr1.i_din_a, tr1.i_addr_a, tr1.o_dout_a, tr1.error_a, tr2.error_a);
        end else begin
          fail++;
          $display(
              $time,
              "[MON] addr_a = %0d \t din_a = %0d \t dout_a = %0d \t  error_a = %0d \t error_a = %0d",
              tr1.i_din_a, tr1.i_addr_a, tr1.o_dout_a, tr1.error_a, tr2.error_a);

        end
      end
    end
    // PORT_B
    if (!tr1.i_we_b) begin
      if ((tr1.i_din_b == tr2.o_dout_b) && (tr1.error_b == tr2.error_b)) begin
        pass++;
        $display(
            $time,
            "[SCO] addr_b = %0d \t din_b = %0d \t dout_b = %0d \t  error_b = %0d \t error_b = %0d",
            tr1.i_din_b, tr1.i_addr_b, tr1.o_dout_b, tr1.error_b, tr2.error_b);
      end else begin
        fail++;
        $display(
            $time,
            "[MON] addr_b = %0d \t din_b = %0d \t dout_b = %0d \t  error_b = %0d \t error_ b= %0d",
            tr1.i_din_b, tr1.i_addr_b, tr1.o_dout_b, tr1.error_b, tr2.error_b);

      end
    end


  endtask
endclass
