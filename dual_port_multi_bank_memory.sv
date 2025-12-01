/////////////////////////////////////////////////////////////////////////////////////
// Design of multi bank memory by using a designed memory bank by instantiating them .
// Here we have a mutiple bank memories are created based on address sel bits we
// are selecting which memory bank have to access among multiple here these
// address selection bits and each memory bank has there seperate address
// . The main reason of using this multi bank memory is to read / write
// operations done in a parallel way.
////////////////////////////////////////////////////////////////////////////////////
`include "decoder.sv"
`include "dual_port_memory_latency.sv"
module dual_port_multi_bank_memory #(
    parameter WIDTH = 8,
    parameter ADDR_TOTAL = 5,
    parameter NUM_BANK = 4
) (
    input i_clk_a,
    i_clk_b,
    input i_en_a,
    i_en_b,
    input i_we_a,
    i_we_b,
    input [WIDTH-1:0] i_din_a,
    i_din_b,
    input [ADDR_TOTAL-1:0] i_addr_a,
    i_addr_b,
    output logic [WIDTH-1:0] o_dout_a,
    o_dout_b
);

  localparam BANK_BITS = $clog2(NUM_BANK);
  localparam ADDR_PER_BANK = ADDR_TOTAL - BANK_BITS;

  logic [BANK_BITS-1:0] bank_sel_a, bank_sel_b;
  logic [ADDR_PER_BANK-1:0] bank_addr_a, bank_addr_b;

  assign bank_sel_a  = i_addr_a[ADDR_TOTAL-1 : ADDR_TOTAL-BANK_BITS];
  assign bank_addr_a = i_addr_a[ADDR_PER_BANK-1:0];

  assign bank_sel_b  = i_addr_b[ADDR_TOTAL-1 : ADDR_TOTAL-BANK_BITS];
  assign bank_addr_b = i_addr_b[ADDR_PER_BANK-1:0];

  // FIX: Declare decoder outputs with correct width
  logic [NUM_BANK-1:0] out_a;
  logic [NUM_BANK-1:0] out_b;
  decoder #(
      .A(BANK_BITS),
      .NUM_BANK(NUM_BANK)
  ) dut_a (
      .in (bank_sel_a),
      .out(out_a)
  );
  decoder #(
      .A(BANK_BITS),
      .NUM_BANK(NUM_BANK)
  ) dut_b (
      .in (bank_sel_b),
      .out(out_b)
  );

  logic [WIDTH-1:0] bank_dout_a[NUM_BANK-1:0];
  logic [WIDTH-1:0] bank_dout_b[NUM_BANK-1:0];

  genvar i;
  generate
    for (i = 0; i < NUM_BANK; i++) begin
      dual_port_memory_latency #(
          .WIDTH(WIDTH),
          .ADDR_WIDTH(ADDR_PER_BANK)
      ) bank_inst (
          .i_clk_a(i_clk_a),
          .i_clk_b(i_clk_b),
          .i_en_a (i_en_a),
          .i_en_b (i_en_b),
          .i_we_a (i_we_a),
          .i_we_b (i_we_b),

          .i_din_a (i_din_a),
          .i_din_b (i_din_b),
          .i_addr_a(bank_addr_a),
          .i_addr_b(bank_addr_b),
          .o_dout_a(bank_dout_a[i]),
          .o_dout_b(bank_dout_b[i])
      );
    end
  endgenerate

  always_comb begin
    o_dout_a = bank_dout_a[bank_sel_a];
    o_dout_b = bank_dout_b[bank_sel_b];
  end

endmodule

