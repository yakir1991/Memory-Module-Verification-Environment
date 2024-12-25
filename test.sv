// This file defines a test program for a memory module in SystemVerilog.
// The test program creates an environment, sets the number of transactions to generate,
// and runs the environment to perform the test.

program test(mem_if vif);

  // Declare environment instance
  environment env;

  // Initial block to run the test
  initial begin
    // Create the environment
    env = new(vif);

    // Set the repeat count of the generator (number of transactions to generate)
    env.gen.repeat_count = 200; 

    // Run the environment
    env.run();
  end

endprogram
