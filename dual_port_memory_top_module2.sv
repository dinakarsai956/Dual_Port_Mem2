//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Designing Dual Port Memory implementing features such as  1. LATENCY
//                                                           2 .Error Correction Code
//                                                           3. Multi_Bank_Memory
//                                                           4 . Multi_Bank_Memory by Control Implementation
//
// Here we have inputs such as i_clk_a, i_clk_b, i_en_a, i_en_b, i_we_a,
// i_we_b, [WIDTH-1:0] i_din_a, i_din_b, [ADDR-1:0] i_addr_a, i_addr_b ,  
// and outputs are [WIDTH-1:0] dout_a, dout_b.
// The dual port memory here i designed was working based on when the i_en_a, i_en_b are high the data  will get read or write operation takes place when
// i_we_a and i_we_b are high write operation takes place when and based on address it will store the data it is low read  opeartion takes place based on address 
// location read will takes place. 
// 1 . LATENCY : latency feature will delay the signals as per the parameters WRITE_LATENCY_A, READ_LATENCY_A, WRITE_LATENCY_B, READ_LATENCY_B values of
// two ports.
//
// 2. Error Correction Code : In error correction code it will add the parity bits with help of hamming encoder and send it to hamming decoder it will
// detect the error bits and identify the error bit and flip it and produce the corrected bits of the data.
// 
// 3. Multi_Bank_Memory : In multi bank memory we design a memory module and by help of generate block we will develop memory banks by memory banks we  will 
// get based on total address the total address of two MSB bits of address total the bank memory will produce memory bank.
//
// 4 . Multi_Bank_Memory by control implementation : The multi bank memory control implementation was designed by adding a decoder to the multi bank memory 
// it will decide which will have to produce the memory bank it will also depends upon total address of first two MSB bits .
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`include "hamming_encoder.sv"
`include "hamming_decoder.sv"
`include "dual_port_multi_bank_memory.sv"
module dual_port_memory_top_module2 #(
    parameter WIDTH = 8,
    parameter CODE_WIDTH = 12,
    parameter ADDR_WIDTH = 5,
    parameter WRITE_LATENCY_A = 1,
    parameter READ_LATENCY_A = 1,
    parameter WRITE_LATENCY_B = 1,
    parameter READ_LATENCY_B = 1,
    parameter NUM_BANK = 4,
    parameter DEPTH = 2 ** ADDR_WIDTH
) (
    input i_clk_a,
    i_clk_b,
    input i_en_a,
    i_en_b,
    input i_we_a,
    i_we_b,
    input [WIDTH-1:0] i_din_a,
    i_din_b,
    input [ADDR_WIDTH-1:0] i_addr_a,
    i_addr_b,
    output logic [WIDTH-1:0] o_dout_a1,
    o_dout_b1
);

  logic [WIDTH-1:0] out_a, out_b;  // latency outputs 
  logic [CODE_WIDTH-1:0] e_out_a, e_out_b;
  logic o_error_detected_a, o_error_detected_b;
  logic o_error_corrected_a, o_error_corrected_b;
  logic [WIDTH-1:0] m_dout_a, m_dout_b;  // multi bank memory output 
  hamming_encoder dut_a (
      .data_in (i_din_a),
      .data_out(e_out_a)
  );
  hamming_encoder dut_b (
      .data_in (i_din_b),
      .data_out(e_out_b)
  );
  hamming_decoder dut_d (
      .data_in(e_out_a),
      .data_out(o_dout_a1),
      .error_detected(o_error_detected_a),
      .error_corrected(o_error_corrected_a)
  );
  hamming_decoder dut_e (
      .data_in(e_out_b),
      .data_out(o_dout_b1),
      .error_detected(o_error_detected_b),
      .error_corrected(o_error_corrected_b)
  );
  dual_port_multi_bank_memory #(
      .WIDTH(WIDTH),
      .ADDR_TOTAL(ADDR_WIDTH),
      .NUM_BANK(NUM_BANK)
  ) dut_f (
      .i_clk_a (i_clk_a),
      .i_clk_b (i_clk_b),
      .i_en_a  (i_en_a),
      .i_en_b  (i_en_b),
      .i_we_a  (i_we_a),
      .i_we_b  (i_we_b),
      .i_din_a (o_dout_a1),
      .i_din_b (o_dout_b1),
      .i_addr_a(i_addr_a),
      .i_addr_b(i_addr_b),
      .o_dout_a(m_dout_a),
      .o_dout_b(m_dout_b)
  );
endmodule
