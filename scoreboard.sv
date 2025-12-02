//////////////////////////////////////////////////////////////////////////////////////////////
// Scoreboard is nothing but to compare the actual output and refernce output
// it will get the output by using mailbox from monitor class and reference
// class .
////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV

class scoreboard;
  // Mailboxes from reference and monitors
  mailbox #(transaction) ref2sco;
  mailbox #(transaction) mon2scoa;
  mailbox #(transaction) mon2scob;

  int pass = 0;
  int fail = 0;
  int count = 0;
  int num_transactions = 50;  // expected transactions
  event sco_done;

  // Constructor
  function new(mailbox#(transaction) ref2sco, mailbox#(transaction) mon2scoa,
               mailbox#(transaction) mon2scob);
    this.ref2sco  = ref2sco;
    this.mon2scoa = mon2scoa;
    this.mon2scob = mon2scob;
  endfunction

  // Main scoreboard task
  task main();
    transaction tr_ref;
    transaction tr_mon_a, tr_mon_b;

    forever begin
      // Stop condition
      if (count == num_transactions) begin
        $display("\n[SCO] Scoreboard completed %0d transactions", count);
        $display("[SCO] PASS = %0d, FAIL = %0d\n", pass, fail);
        ->sco_done;  // trigger event
        break;
      end

      // Non-blocking mailbox reads
      if (ref2sco.try_get(tr_ref) && mon2scoa.try_get(tr_mon_a) && mon2scob.try_get(tr_mon_b)) begin
        count++;

        // ---------------- PORT A ----------------
        if (!tr_ref.i_we_a) begin
          if ((tr_ref.i_din_a == tr_mon_a.o_dout_a) && (tr_ref.error_a == tr_mon_a.error_a)) begin
            pass++;
            $display("[SCO] PORT_A PASS: addr=%0d din=%0d dout=%0d err_ref=%0d err_mon=%0d",
                     tr_ref.i_addr_a, tr_ref.i_din_a, tr_mon_a.o_dout_a, tr_ref.error_a,
                     tr_mon_a.error_a);
          end else begin
            fail++;
            $display("[SCO] PORT_A FAIL: addr=%0d din=%0d dout=%0d err_ref=%0d err_mon=%0d",
                     tr_ref.i_addr_a, tr_ref.i_din_a, tr_mon_a.o_dout_a, tr_ref.error_a,
                     tr_mon_a.error_a);

            // Self-correct the monitor transaction
            tr_mon_a.o_dout_a = tr_ref.i_din_a;
            tr_mon_a.error_a  = tr_ref.error_a;
            $display("[SCO] PORT_A CORRECTED: dout=%0d err=%0d", tr_mon_a.o_dout_a,
                     tr_mon_a.error_a);
          end
        end

        // ---------------- PORT B ----------------
        if (!tr_ref.i_we_b) begin
          if ((tr_ref.i_din_b == tr_mon_b.o_dout_b) && (tr_ref.error_b == tr_mon_b.error_b)) begin
            pass++;
            $display("[SCO] PORT_B PASS: addr=%0d din=%0d dout=%0d err_ref=%0d err_mon=%0d",
                     tr_ref.i_addr_b, tr_ref.i_din_b, tr_mon_b.o_dout_b, tr_ref.error_b,
                     tr_mon_b.error_b);
          end else begin
            fail++;
            $display("[SCO] PORT_B FAIL: addr=%0d din=%0d dout=%0d err_ref=%0d err_mon=%0d",
                     tr_ref.i_addr_b, tr_ref.i_din_b, tr_mon_b.o_dout_b, tr_ref.error_b,
                     tr_mon_b.error_b);

            // Self-correct the monitor transaction
            tr_mon_b.o_dout_b = tr_ref.i_din_b;
            tr_mon_b.error_b  = tr_ref.error_b;
            $display("[SCO] PORT_B CORRECTED: dout=%0d err=%0d", tr_mon_b.o_dout_b,
                     tr_mon_b.error_b);
          end
        end
      end else begin
        #1;  // small wait to avoid tight loop
      end
    end
  endtask

endclass
`endif

