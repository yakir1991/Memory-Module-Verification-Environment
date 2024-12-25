// This file defines a direct test for a memory module in SystemVerilog.
// The direct test includes the environment setup and specific test sequences
// to directly verify the functionality of the memory module.

`include "environment.sv"

// Define the direct test module
module direct_test(mem_if vif);

  // Declare environment instance
  environment env;

  // Initial block to run the direct test
  initial begin
    // Create the environment
    env = new(vif);

    // Perform pre-test activities (e.g., reset)
    env.pre_test();

    // Direct test sequences can be added here
    // Example: Generate a specific transaction and send it to the driver
    env.gen.repeat_count = 1; // Set the number of transactions to generate
    env.gen.main(); // Generate and send the transaction

    // Additional direct test sequences can be added as needed

    // ----------------------------------------
    // 1. Write and Read to a specific memory location
    // ----------------------------------------
    $display("1. Write and Read to a specific memory location");
    vif.addr <= 3'b001;  // Example address
    vif.wr_data <= 8'hAA;  // Write some data
    vif.rd_wr <= 0;  // Write operation
    vif.enable <= 1;
    @(posedge vif.clk);
    vif.enable <= 0;

    // Wait one clock cycle for the write to settle
    @(posedge vif.clk);

    // Now read from the same address
    vif.rd_wr <= 1;  // Read operation
    vif.enable <= 1;
    @(posedge vif.clk);
    vif.enable <= 0;

    // Wait one more clock cycle for the read data to be valid
    @(posedge vif.clk);

    // Check if the data read matches the data written
    if (vif.rd_data !== 8'hAA) begin
      $display("ERROR: Read data does not match written data at address 3'b001.");
    end else begin
      $display("PASS: Read data matches written data at address 3'b001.");
    end

    // ----------------------------------------
    // 2. Write and Read to all memory locations
    // ----------------------------------------
    $display("2. Write and Read to all memory locations");
    for (int i = 0; i < 8; i++) begin
      vif.addr <= i[2:0];  // Set address
      vif.wr_data <= 8'hA0 + i;  // Write unique data for each address
      vif.rd_wr <= 0;  // Write operation
      vif.enable <= 1;
      @(posedge vif.clk);
      vif.enable <= 0;

      // Wait one clock cycle for the write to settle
      @(posedge vif.clk);

      // Now read from the same address
      vif.rd_wr <= 1;  // Read operation
      vif.enable <= 1;
      @(posedge vif.clk);
      vif.enable <= 0;

      // Wait one more clock cycle for the read data to be valid
      @(posedge vif.clk);

      // Check if the data read matches the data written
      if (vif.rd_data !== 8'hA0 + i) begin
        $display("ERROR: Read data at address %0d does not match written data.", i);
      end else begin
        $display("PASS: Read data at address %0d matches written data.", i);
      end
    end

    // ----------------------------------------
    // 3. Check default memory value after reset
    // ----------------------------------------
    $display("3. Check default memory value after reset");
    vif.rst <= 1;  // Assert reset
    @(posedge vif.clk);
    vif.rst <= 0;  // Deassert reset

    for (int i = 0; i < 8; i++) begin
      vif.addr <= i[2:0];  // Set address
      vif.rd_wr <= 1;  // Read operation
      vif.enable <= 1;
      @(posedge vif.clk);
      vif.enable <= 0;

      // Wait one more clock cycle for the read data to be valid
      @(posedge vif.clk);

      // Check if the data read is the default value (hFF)
      if (vif.rd_data !== 8'hFF) begin
        $display("ERROR: Default value at address %0d is not hFF.", i);
      end else begin
        $display("PASS: Default value at address %0d is hFF.", i);
      end
    end

    // ----------------------------------------
    // 4. Reset during write/read operations
    // ----------------------------------------
    $display("4. Reset during write/read operations");

    // Write to a few locations first
    for (int i = 0; i < 4; i++) begin
      vif.addr <= i[2:0];
      vif.wr_data <= 8'hB0 + i;
      vif.rd_wr <= 0;  // Write operation
      vif.enable <= 1;
      @(posedge vif.clk);
      vif.enable <= 0;

      // Wait one clock cycle for the write to settle
      @(posedge vif.clk);
    end

    // Assert reset during operation
    vif.rst <= 1;
    @(posedge vif.clk);
    vif.rst <= 0;  // Deassert reset
    $display("Reset applied.");

    // Check if all addresses return the default value after reset
    for (int i = 0; i < 8; i++) begin
      vif.addr <= i[2:0];  // Set address
      vif.rd_wr <= 1;  // Read operation
      vif.enable <= 1;
      @(posedge vif.clk);
      vif.enable <= 0;

      // Wait one more clock cycle for the read data to be valid
      @(posedge vif.clk);

      // Check if the data read is the default value (hFF)
      if (vif.rd_data !== 8'hFF) begin
        $display("ERROR: Address %0d did not return default value after reset.", i);
      end else begin
        $display("PASS: Address %0d returned default value after reset.", i);
      end
    end

    $finish;
  end

endmodule
