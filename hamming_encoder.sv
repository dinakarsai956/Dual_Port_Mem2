/////////////////////////////////////////////////////////////////////////////////////
//  Design of hamming encoder for error correction code latency in dual port
//  memory by hamming encoder it will detect the error bit in the data by
//  adding a parity bits to them whenever it detects the error bit it will
//  identify and flip the bit.
//
//////////////////////////////////////////////////////////////////////////////////////
module hamming_encoder (
    input  wire [ 7:0] data_in,
    output wire [11:0] data_out
);

  // Place data bits into codeword positions
  assign data_out[2] = data_in[0];
  assign data_out[4] = data_in[1];
  assign data_out[5] = data_in[2];
  assign data_out[6] = data_in[3];
  assign data_out[8] = data_in[4];
  assign data_out[9] = data_in[5];
  assign data_out[10] = data_in[6];
  assign data_out[11] = data_in[7];

  // Parity bit computation (covers specific coded positions)
  assign data_out[0]  = data_out[1] ^ data_out[3] ^ data_out[5] ^ data_out[7] ^ data_out[9] ^ data_out[11];
  assign data_out[1]  = data_out[2] ^ data_out[3] ^ data_out[6] ^ data_out[7] ^ data_out[10] ^ data_out[11];
  assign data_out[3] = data_out[4] ^ data_out[5] ^ data_out[6] ^ data_out[7];
  assign data_out[7] = data_out[8] ^ data_out[9] ^ data_out[10] ^ data_out[11];

endmodule


