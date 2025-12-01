/////////////////////////////////////////////////////////////////////////////
//
// Declaring parameters of top module in dual port memory.
// WIDTH : For data inputs
// CODE_WIDTH : For data inputs + parity bits
// ADDR_WIDTH : Address input for dual port memory
// WRITE_LATENCY_A, READ_LATENCY_A : parameters for write and read for port A
// WRITE_LATENCY_B, READ_LATENCY_B  : parameters for write and read for port B
// NUM_BANK :  parameter for number of memory banks .
///////////////////////////////////////////////////////////////////////////////

parameter WIDTH = 8;
parameter CODE_WIDTH = 12;
parameter ADDR_WIDTH = 10;
parameter WRITE_LATENCY_A = 4;
parameter READ_LATENCY_A = 5;
parameter WRITE_LATENCY_B = 4;
parameter READ_LATENCY_B = 5;
parameter NUM_BANK = 4;
parameter DEPTH = 2 ** ADDR_WIDTH;
