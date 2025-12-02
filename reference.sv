//////////////////////////////////////////////////////////////////////////////////////////
//  Designing of reference class for dual port memory it get the data inputs
//  from monitor class by help of mailbox by get method and we design the dual
//  port memory by including features such as latency, errror correction code,
//  multi bank memory control implementation and compare them in scoreboard.
//////////////////////////////////////////////////////////////////////////////////////////

`ifndef REFERENCE_SV
`define REFERENCE_SV
class reference;

  // Mailboxes
  mailbox #(transaction) mon2refa;
  mailbox #(transaction) mon2refb;
  mailbox #(transaction) ref2sco;

  // Memory: CODE_WIDTH must be defined elsewhere (parameter or `define)
  logic [CODE_WIDTH-1:0] mem[NUM_BANK-1:0][DEPTH-1:0];

  // Constructor
  function new(mailbox#(transaction) mon2refa, mailbox#(transaction) mon2refb,
               mailbox#(transaction) ref2sco);
    this.mon2refa = mon2refa;
    this.mon2refb = mon2refb;
    this.ref2sco  = ref2sco;

    foreach (mem[i, j]) mem[i][j] = '0;
  endfunction


  // ---------------------------
  // Address → Bank + Depth
  // ---------------------------
  function int select_bank(int addr);
    return addr % NUM_BANK;
  endfunction

  function int local_addr(int addr);
    return addr / NUM_BANK;
  endfunction


  // ---------------------------
  // Hamming Encode
  // ---------------------------
  function automatic bit [CODE_WIDTH-1:0] hamming_encode(bit [WIDTH-1:0] data);
    bit p1, p2, p4, p8;

    p1 = data[0] ^ data[1] ^ data[3] ^ data[4] ^ data[6];
    p2 = data[0] ^ data[2] ^ data[3] ^ data[5] ^ data[6];
    p4 = data[1] ^ data[2] ^ data[3] ^ data[7];
    p8 = data[4] ^ data[5] ^ data[6] ^ data[7];

    return {p8, p4, p2, p1, data};
  endfunction


  // ---------------------------
  // Hamming Decode
  // ---------------------------
  function automatic void hamming_decode(input bit [CODE_WIDTH-1:0] encoded_data,
                                         output bit [WIDTH-1:0] data_out, output bit error_flag);
    bit [WIDTH-1:0] d;
    bit p1, p2, p4, p8;
    bit s1, s2, s4, s8;
    int syndrome;
    {p8, p4, p2, p1, d} = encoded_data;
    syndrome = {s8, s4, s2, s1};

    s1 = p1 ^ d[0] ^ d[1] ^ d[3] ^ d[4] ^ d[6];
    s2 = p2 ^ d[0] ^ d[2] ^ d[3] ^ d[5] ^ d[6];
    s4 = p4 ^ d[1] ^ d[2] ^ d[3] ^ d[7];
    s8 = p8 ^ d[4] ^ d[5] ^ d[6] ^ d[7];
    error_flag = (syndrome != 0);
    data_out = d;
  endfunction


  // ---------------------------
  // Port A Processing
  // ---------------------------
  task automatic portA();

    transaction tr1, tr2;
    bit [WIDTH-1:0] decoded_a;
    bit [CODE_WIDTH-1:0] encoded_a;
    bit error_a;
    int bank;
    int depth;

    forever begin

      mon2refa.get(tr1);

      bank  = select_bank(tr1.i_addr_a);
      depth = local_addr(tr1.i_addr_a);

      if (tr1.i_we_a) begin  // WRITE
        encoded_a = hamming_encode(tr1.i_din_a);
        mem[bank][depth] = encoded_a;
        $display("[REF][A] WRITE addr=%0d bank=%0d enc=0x%0h time=%0t", tr1.i_addr_a, bank,
                 encoded_a, $time);
      end else begin  // READ
        encoded_a = mem[bank][depth];
        hamming_decode(encoded_a, decoded_a, error_a);

        tr2 = new();
        tr2.i_addr_a = tr1.i_addr_a;
        tr2.i_din_a = decoded_a;
        tr2.error_a = error_a;
        ref2sco.put(tr2);

        $display("[REF][A] READ  addr=%0d bank=%0d data=0x%0h err=%0b time=%0t", tr1.i_addr_a,
                 bank, decoded_a, error_a, $time);
      end
    end
  endtask


  // ---------------------------
  // Port B Processing
  // ---------------------------
  task automatic portB();

    transaction tr1, tr2;
    bit [WIDTH-1:0] decoded_b;
    bit [CODE_WIDTH-1:0] encoded_b;
    bit error_b;
    int bank;
    int depth;

    forever begin

      mon2refb.get(tr1);

      bank  = select_bank(tr1.i_addr_b);
      depth = local_addr(tr1.i_addr_b);

      if (tr1.i_we_b) begin  // WRITE
        encoded_b = hamming_encode(tr1.i_din_b);
        mem[bank][depth] = encoded_b;
        $display("[REF][B] WRITE addr=%0d bank=%0d enc=0x%0h time=%0t", tr1.i_addr_b, bank,
                 encoded_b, $time);
      end else begin  // READ
        encoded_b = mem[bank][depth];
        hamming_decode(encoded_b, decoded_b, error_b);

        tr2 = new();
        tr2.i_addr_b = tr1.i_addr_b;
        tr2.i_din_b = decoded_b;
        tr2.error_b = error_b;
        ref2sco.put(tr2);

        $display("[REF][B] READ  addr=%0d bank=%0d data=0x%0h err=%0b time=%0t", tr1.i_addr_a,
                 bank, decoded_b, error_b, $time);
      end
    end
  endtask
endclass
`endif
