////////////////////////////////////////////////////////////////////////////////////////////
//
//  Design of dual port memory using latency feature , where latency feature
//  will delay the signals for read and write the operations using parameters
//  WRITE_LATENCY, READ_LATENCY. Here we are designing a parameters using
//  WIDTH, ADDR, DEPTH, READ_LATENCY, WRITE_LATENCY . Based on i_en_a , i_en_b
//  signal it depends whether to perform operation or not here when i_en_a,
//  i_en_b is high it will perform read or write when i_we_a, i_we_b is high 
//  it will write when it is low it will read . based on address i_addr_a,
//  i_addr_b will select location of memory access. Based on latency
//  parameters and i_en_a, i_en_b, i_we_a, i_we_b it will write and read. 
//
///////////////////////////////////////////////////////////////////////////////////////////////


module dual_port_memory_latency #(
    parameter integer WIDTH           = 8,
    parameter integer ADDR_WIDTH      = 4,
    parameter integer DEPTH           = 2 ** ADDR_WIDTH,
    parameter integer WRITE_LATENCY_A = 0,
    parameter integer READ_LATENCY_A  = 0,
    parameter integer WRITE_LATENCY_B = 0,
    parameter integer READ_LATENCY_B  = 0
) (
    // -------- Port A --------
    input  wire                   i_clk_a,
    input  wire                   i_we_a,
    input  wire                   i_en_a,
    input  wire  [ADDR_WIDTH-1:0] i_addr_a,
    input  wire  [     WIDTH-1:0] i_din_a,
    output logic [     WIDTH-1:0] o_dout_a = '0,

    // -------- Port B --------
    input  wire                   i_clk_b,
    input  wire                   i_we_b,
    input  wire                   i_en_b,
    input  wire  [ADDR_WIDTH-1:0] i_addr_b,
    input  wire  [     WIDTH-1:0] i_din_b,
    output logic [     WIDTH-1:0] o_dout_b = '0
);

  // -------------------------
  // Memory Array
  // -------------------------
  logic [WIDTH-1:0] mem[0:DEPTH-1];

  // Read enable = en AND not write
  wire ren_a = i_en_a & ~i_we_a;
  wire ren_b = i_en_b & ~i_we_b;

  // =========================
  // WRITE PIPELINES (A & B)
  // =========================
  typedef struct packed {
    logic                  en;
    logic                  we;
    logic [ADDR_WIDTH-1:0] addr;
    logic [WIDTH-1:0]      din;
  } wr_req_t;

  wr_req_t wpipe_a[0:WRITE_LATENCY_A];
  wr_req_t wpipe_b[0:WRITE_LATENCY_B];

  integer  wa;
  always_ff @(posedge i_clk_a) begin
    if (WRITE_LATENCY_A > 0) for (wa = WRITE_LATENCY_A; wa >= 1; wa--) wpipe_a[wa] <= wpipe_a[wa-1];

    wpipe_a[0] <= '{i_en_a, i_we_a, i_addr_a, i_din_a};

    if (wpipe_a[WRITE_LATENCY_A].en & wpipe_a[WRITE_LATENCY_A].we)
      mem[wpipe_a[WRITE_LATENCY_A].addr] <= wpipe_a[WRITE_LATENCY_A].din;
  end

  integer wb;
  always_ff @(posedge i_clk_b) begin
    if (WRITE_LATENCY_B > 0) for (wb = WRITE_LATENCY_B; wb >= 1; wb--) wpipe_b[wb] <= wpipe_b[wb-1];

    wpipe_b[0] <= '{i_en_b, i_we_b, i_addr_b, i_din_b};

    if (wpipe_b[WRITE_LATENCY_B].en & wpipe_b[WRITE_LATENCY_B].we)
      mem[wpipe_b[WRITE_LATENCY_B].addr] <= wpipe_b[WRITE_LATENCY_B].din;
  end

  // =========================
  // READ PIPELINES (A & B)
  // =========================

  // ---- Port A ----
  generate
    if (READ_LATENCY_A == 0) begin : GA_READ0
      logic [ADDR_WIDTH-1:0] addr_reg;
      logic                  ren_reg;
      always_ff @(posedge i_clk_a) begin
        addr_reg <= i_addr_a;
        ren_reg  <= ren_a;
        if (ren_reg) o_dout_a <= mem[addr_reg];
      end
    end else begin : GA_READN
      logic   [ADDR_WIDTH-1:0] raddr_pipe[0:READ_LATENCY_A-1];
      logic                    ren_pipe  [0:READ_LATENCY_A-1];
      integer                  ra;
      always_ff @(posedge i_clk_a) begin
        for (ra = READ_LATENCY_A - 1; ra >= 1; ra--) begin
          raddr_pipe[ra] <= raddr_pipe[ra-1];
          ren_pipe[ra]   <= ren_pipe[ra-1];
        end
        raddr_pipe[0] <= i_addr_a;
        ren_pipe[0]   <= ren_a;
        if (ren_pipe[READ_LATENCY_A-1]) o_dout_a <= mem[raddr_pipe[READ_LATENCY_A-1]];
      end
    end
  endgenerate

  // ---- Port B ----
  generate
    if (READ_LATENCY_B == 0) begin : GB_READ0
      logic [ADDR_WIDTH-1:0] addr_reg;
      logic                  ren_reg;
      always_ff @(posedge i_clk_b) begin
        addr_reg <= i_addr_b;
        ren_reg  <= ren_b;
        if (ren_reg) o_dout_b <= mem[addr_reg];
      end
    end else begin : GB_READN
      logic   [ADDR_WIDTH-1:0] raddr_pipe[0:READ_LATENCY_B-1];
      logic                    ren_pipe  [0:READ_LATENCY_B-1];
      integer                  rb;
      always_ff @(posedge i_clk_b) begin
        for (rb = READ_LATENCY_B - 1; rb >= 1; rb--) begin
          raddr_pipe[rb] <= raddr_pipe[rb-1];
          ren_pipe[rb]   <= ren_pipe[rb-1];
        end
        raddr_pipe[0] <= i_addr_b;
        ren_pipe[0]   <= ren_b;
        if (ren_pipe[READ_LATENCY_B-1]) o_dout_b <= mem[raddr_pipe[READ_LATENCY_B-1]];
      end
    end
  endgenerate

endmodule

