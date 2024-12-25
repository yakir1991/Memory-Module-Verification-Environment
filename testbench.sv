// This file defines the top-level testbench module for a memory module in SystemVerilog.
// The testbench includes clock generation, VCD dump for waveform viewing, and instantiation
// of the interface, test program, and Device Under Test (DUT).

// Author of the verification environment: Yakir Aqua

module testbench_top;

  // Declare clock and reset signals
  bit clk = 0;
  bit rst;

  // Clock generation: Toggle clk every 5 time units
  always #5 clk = ~clk;

  // VCD dump for waveform viewing
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(5);
  end

  // Instantiate interface to connect DUT and testbench
  mem_if vif(clk);  // Updated to use the ALU memory interface

  // Instantiate the test program, pass interface handle
  test t1(vif);

  // Instantiate DUT (Device Under Test), pass interface handle
  memory DUT (vif);  // Updated to use the ALU with memory DUT
  
  // Instantiate the direct test
  //direct_test d_test(vif);  // Run the direct test

endmodule


