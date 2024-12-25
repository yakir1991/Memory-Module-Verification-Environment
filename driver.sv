// This file defines a driver class for a memory module in SystemVerilog.
// The driver class is responsible for receiving transactions from the generator
// and driving the corresponding signals to the memory interface.

`define DRIV_IF vif.driver

class driver;

  // Count the number of transactions driven
  int num_transactions;

  // Virtual interface handle
  virtual mem_if vif;
  
  // Mailbox handle to receive transactions from generator
  mailbox gen2drv;
  
  // Constructor
  // Initializes the virtual interface and mailbox handle
  function new(virtual mem_if vif, mailbox gen2drv);
    this.vif = vif;
    this.gen2drv = gen2drv;
    num_transactions = 0;
  endfunction
  
  // Reset task
  // Drives the reset sequence to the interface signals
  task reset;
    $display("[Driver] Reset Started");
    `DRIV_IF.rst <= 1;
    `DRIV_IF.enable <= 0;
    `DRIV_IF.rd_wr <= 0;
    `DRIV_IF.addr <= 3'b000;
    `DRIV_IF.wr_data <= 8'h00;
    @(posedge `DRIV_IF.clk);
    `DRIV_IF.rst <= 0;
    $display("[Driver] Reset Ended");
  endtask

  // Drive task - drives the transaction items to interface signals
  task drive;
    transaction trans;
    `DRIV_IF.enable <= 0;
    gen2drv.get(trans); // Get the transaction from the mailbox
    
    $display("--------- [Driver-TRANSFER: %0d] ---------", num_transactions);
    
    @(posedge `DRIV_IF.clk); // Use the clock from the driver modport
    
    // Set address
    `DRIV_IF.addr <= trans.addr;
    
    if (trans.rst) begin
      $display("[Driver] Reset Started");
      `DRIV_IF.rst <= 1;
      `DRIV_IF.enable <= 0;
      `DRIV_IF.rd_wr <= 0;
      `DRIV_IF.addr <= 3'b000;
      @(posedge `DRIV_IF.clk);
      `DRIV_IF.rst <= 0;
      $display("[Driver] Reset Ended");
    end
    
    if (trans.rd_wr == 0) begin // Write operation
      `DRIV_IF.enable <= trans.enable;
      `DRIV_IF.rd_wr <= trans.rd_wr;
      `DRIV_IF.wr_data <= trans.wr_data;
      $display("\tADDR = %0h \tWDATA = %0h", trans.addr, trans.wr_data);
      @(posedge `DRIV_IF.clk); // Wait for one clock cycle
      `DRIV_IF.enable <= 0;     // Deassert enable
    end

    if (trans.rd_wr == 1) begin // Read operation
      `DRIV_IF.enable <= trans.enable;
      `DRIV_IF.rd_wr <= trans.rd_wr;
      @(posedge `DRIV_IF.clk); // Wait for one clock cycle
      `DRIV_IF.enable <= 0;    // Deassert enable
      @(posedge `DRIV_IF.clk); // Wait for one clock cycle
      trans.rd_data = `DRIV_IF.rd_data; // Capture read data
      $display("\tADDR = %0h \tRDATA = %0h", trans.addr, `DRIV_IF.rd_data);
    end

    $display("-----------------------------------------");
    num_transactions++;
  endtask

  // Main task
  // Continuously drives transactions to the interface
  task main;
    forever begin
      drive();
    end
  endtask

endclass
