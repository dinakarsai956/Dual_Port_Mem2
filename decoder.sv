////////////////////////////////////////////////////////////////////////////
//  Designing a parametrized decoder for selection of banks in multi bank
//  memory . Based on this it will select which address have to activate  
////////////////////////////////////////////////////////////////////////////
module decoder #(
    parameter A = 2,
    parameter NUM_BANK = 4
) (
    input [A-1:0] in,

    output logic [NUM_BANK-1:0] out
);
  always_comb begin
    case (in)
      2'b00:   out = 'd0;
      2'b01:   out = 'd1;
      2'b10:   out = 'd2;
      2'b11:   out = 'd3;
      default: out = 'dx;
    endcase
  end
endmodule
