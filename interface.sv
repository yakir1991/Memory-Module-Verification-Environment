// This file defines an interface for a memory module in SystemVerilog.
// The interface includes a modport for a driver, which specifies the direction of signals
// used to interact with the memory module.

interface mem_if(
  input logic clk
);
  logic enable, rd_wr, rst;
  logic [2:0] addr;
  logic [7:0] wr_data;
  logic [7:0] rd_data;
  

  // Modports for different components
  modport DUT (input clk, rst, enable, rd_wr, addr, wr_data, output rd_data);
  modport driver (input clk, rd_data, output enable, rd_wr, addr, wr_data, rst);
  modport monitor_in (input clk, rst, enable, rd_wr, addr, wr_data);
  modport monitor_out (input clk, rst, enable, rd_wr, rd_data);
endinterface
