////////////////////////////////////////////////////////////////////////////
//
// Design of hamming decoder by taking input and output we are taking extra 
// wire as syndrome xor operation takes place based on parity bit on array
// indices if syndrome is non zero there is error by then we will idnetify 
////////////////////////////////////////////////////////////////////////////

module hamming_decoder (
    input [11:0] data_in,
    output logic error_detected,
    output logic error_corrected,
    output logic [7:0] data_out
);

  logic [ 3:0] syndrome;
  logic [11:0] corrected_code;

  // syndrome calculation for Hamming (12,8)
  assign syndrome[0] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10];
  assign syndrome[1] = data_in[1] ^ data_in[2] ^ data_in[5] ^ data_in[6] ^ data_in[9] ^ data_in[10];
  assign syndrome[2] = data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6];
  assign syndrome[3] = data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10];

  assign error_detected = |syndrome;
  assign error_corrected = |syndrome;  // corrected when syndrome != 0

  always_comb begin
    corrected_code = data_in;  // do not invert all bits
    if (syndrome != 0)
      corrected_code[syndrome-1] = ~corrected_code[syndrome-1];  // flip only error bit
    else corrected_code[syndrome-1] = corrected_code[syndrome-1];

  end

  // Extract data bits (remove parity bits)
  assign data_out = {
    corrected_code[10],
    corrected_code[9],
    corrected_code[8],
    corrected_code[6],
    corrected_code[5],
    corrected_code[4],
    corrected_code[2],
    corrected_code[0]
  };

endmodule

