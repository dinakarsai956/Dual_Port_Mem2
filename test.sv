////////////////////////////////////////////////////////////////////
// Here we are creating the test class for calling the environment
// class of dual port memory testbench.
//
///////////////////////////////////////////////////////////////////
`ifndef TEST_SV
`define TEST_SV
class test;
  environment env;
  virtual dual_port_vif dp_vif;

  function new(virtual dual_port_vif dp_vif);
    this.dp_vif = dp_vif;
    env = new(dp_vif);
  endfunction

  task main();
    env.main();
  endtask

endclass
`endif
