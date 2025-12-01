
/////////////////////////////////////////////////////
//  Hamming decoder testbench it will identify the
//  error in data and correct the bit and produce the 
//  correct data.
///////////////////////////////////////////////////////



module hamming_decoder_testbench;
  logic [11:0] data_in;
  logic [7:0] data_out;
  logic error_detected;
  logic error_corrected;
  hamming_decoder dut (
      .data_in(data_in),
      .data_out(data_out),
      .error_detected(error_detected),
      .error_corrected(error_corrected)
  );
  initial begin
    for (int i = 0; i < 10; i++) begin
      data_in = $random;
      #10;
    end
  end

endmodule
