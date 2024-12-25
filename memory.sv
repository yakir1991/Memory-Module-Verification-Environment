module memory(mem_if.DUT vif);

  // Memory array definition: 8-bit data width, 8 locations
  reg [7:0] mem [0:7];
  reg [7:0] rd_data_next;  // Register to hold the next read data value

  // Initialize memory locations to 'hFF on reset
  integer i;
  always @(posedge vif.rst) begin
    for (i = 0; i < 8; i = i + 1) begin
      mem[i] = 8'hFF;  // Reset all memory locations to FF
      $display("[DUT] Memory[%0d] initialized to: %h", i, mem[i]);
    end
    rd_data_next <= 8'b0; // Reset the next read data value
  end

  // Memory read and write operations
  always @(posedge vif.clk) begin
    if (vif.enable) begin
      if (vif.rd_wr) begin // Read operation
        rd_data_next <= mem[vif.addr]; // Store the next read data
        $display("[DUT] Read from Address %0d: Data = %h", vif.addr, rd_data_next);
      end else begin // Write operation
        mem[vif.addr] <= vif.wr_data; // Write data to memory
        $display("[DUT] Write to Address %0d: Data = %h", vif.addr, vif.wr_data);
      end
    end
  end

  // Output rd_data is delayed by 1 clock cycle
  always @(posedge vif.clk or posedge vif.rst) begin
    if (vif.rst) begin
      vif.rd_data <= 8'b0; // Reset output data
    end else begin
      vif.rd_data <= rd_data_next; // Update output with delayed data
    end
  end

endmodule

