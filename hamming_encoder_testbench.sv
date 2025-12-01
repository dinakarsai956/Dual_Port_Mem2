//////////////////////////////////////////////////////////
//  Testbench for hamming encoder by adding parity bits to
//  hamming encoder .
//
////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module tb_hamming_encoder_8to12 ();

  reg  [ 7:0] data_in;
  wire [11:0] data_out;

  // Instantiate DUT
  hamming_encoder dut (
      .data_in (data_in),
      .data_out(data_out)
  );

  initial begin
    $display("Time | Data_in | Hamming Codeword");
    $display("-----------------------------------");

    data_in = 8'b00000000;
    #10;
    $display("%4t | %b | %b", $time, data_in, data_out);

    data_in = 8'b10101010;
    #10;
    $display("%4t | %b | %b", $time, data_in, data_out);

    data_in = 8'b11110000;
    #10;
    $display("%4t | %b | %b", $time, data_in, data_out);

    data_in = 8'b01010101;
    #10;
    $display("%4t | %b | %b", $time, data_in, data_out);

    data_in = 8'b11111111;
    #10;
    $display("%4t | %b | %b", $time, data_in, data_out);

    $finish;
  end

endmodule

