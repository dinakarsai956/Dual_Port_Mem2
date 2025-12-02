///////////////////////////////////////////////////////////////////////////////////////////////////
//  creating a transaction class by using including all the inputs and outputs
//  and by randomizing variables for inputs and creating a the random values
//  by using constraint . Here we are creating for dual port memory here we
//  are creating a parametrized inputs by randomization pre qualifiers.
///////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef TRANSACTION_SV
`define TRANSACTION_SV
class transaction;
  rand bit i_en_a, i_en_b;  // enable inputs for port_A, port_B
  rand bit i_we_a, i_we_b;  // write enable inputs for port_A, port_B
  randc bit [WIDTH-1:0] i_din_a, i_din_b;
  randc bit [ADDR_WIDTH-1:0] i_addr_a, i_addr_b;
  bit [WIDTH-1:0] o_dout_a, o_dout_b;
  bit error_a, error_b;
  randc bit [NUM_BANK-1:0] i;
  constraint data_range {
    i_din_a inside {[0 : 122]};
    i_din_b inside {[123 : 255]};
  }  // constraints for creating the range for the data
  constraint addr_range {
    i_addr_a inside {[0 : 511]};
    i_addr_b inside {[512 : 1023]};
  }  // constraints for creating the range for the addr
  constraint en_range {
    i_en_a dist {
      1 := 90,
      0 := 10
    };
    i_en_b dist {
      1 := 90,
      0 := 10
    };
  }  // constraint for creating range for enable
  constraint wr_range {
    i_we_a dist {
      1 := 50,
      0 := 50
    };
    i_we_b dist {
      1 := 50,
      0 := 50
    };
  }  // write enable range
  constraint i_range {i inside {[0 : 3]};}
  function void display(string tag);
    $display(
        "i_en_a = %0d \t i_en_b = %0d \t i_we_a = %0d \t i_we_b = %0d \t i_din_a = %0d \t i_din_b = %0d \t i_addr_a = %0d \t i_addr_b = %0d",
        i_en_a, i_en_b, i_we_a, i_we_b, i_din_a, i_din_b, i_addr_a, i_addr_b);
  endfunction

endclass
`endif
