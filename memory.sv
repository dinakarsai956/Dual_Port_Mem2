/////////////////////////////////////////////////////////////////////////
// Design of dual port memory using paremeters WIDTH, ADDR, DEPTH
// and build based on inputs i_din_a, i_din_b and address bits of
// i_addr_a , i_addr_b based on when i_en_a and i-en_b inputs are high 
// read and write operation takes place when i_we_a and i_we_b write 
// takes place and when i_we_a , i_we_b are absent read takes place
//
////////////////////////////////////////////////////////////////////////



module memory #(
    parameter WIDTH = 8,
    ADDR = 3,
    DEPTH = 2 ** ADDR
) (
    input [WIDTH-1:0] i_din_a,
    input [WIDTH-1:0] i_din_b,
    input [ADDR-1:0] i_addr_a,
    input [ADDR-1:0] i_addr_b,
    input i_clk_a,
    i_clk_b,
    input i_en_a,
    i_en_b,
    input i_we_a,
    i_we_b,
    output logic [WIDTH-1:0] o_dout_a,
    output logic [WIDTH-1:0] o_dout_b
);
  logic [WIDTH-1:0] mem[0:DEPTH-1];

  always_ff @(posedge i_clk_a) begin  // memory read or write in port_A
    if (i_en_a) begin
      if (i_we_a) begin
        mem[i_addr_a] <= i_din_a;
      end else o_dout_a <= mem[i_addr_a];
    end
  end

  always_ff @(posedge i_clk_b) begin
    if (i_en_b) begin
      if (i_we_b) begin
        mem[i_addr_b] <= i_din_b;
      end else o_dout_b <= mem[i_addr_b];
    end
  end

endmodule
