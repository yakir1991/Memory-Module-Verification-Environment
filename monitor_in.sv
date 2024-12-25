// This file defines a monitor class for the input signals of a memory module in SystemVerilog.
// The monitor class is responsible for sampling the input signals and sending the captured
// transactions to the scoreboard for verification.

`define MON_IN_IF vif.monitor_in

class monitor_in;

  virtual mem_if vif;  // Virtual interface handle for the memory interface
  mailbox mon_in2scb;  // Mailbox to send the transactions to the scoreboard

  // Constructor
  // Initializes the virtual interface and mailbox handle
  function new(virtual mem_if vif, mailbox mon_in2scb);
    this.vif = vif;
    this.mon_in2scb = mon_in2scb;
  endfunction
  
  // Main task to monitor inputs
  task main;
    transaction trans;
    forever begin
      // Sample the input signals at the next positive clock edge
      @(posedge `MON_IN_IF.clk)
      if (`MON_IN_IF.rst) begin
        // Capture reset signal
        trans.rst = `MON_IN_IF.rst;
        trans.display("[Monitor_in]");
        mon_in2scb.put(trans);
      end else if (`MON_IN_IF.enable) begin
        // Capture transaction details when enable is asserted
        trans = new();
        trans.addr = `MON_IN_IF.addr;
        trans.wr_data = `MON_IN_IF.wr_data;
        trans.rd_wr = `MON_IN_IF.rd_wr;
        trans.enable = `MON_IN_IF.enable;
        
        // Display the transaction and send to scoreboard
        trans.display("[Monitor_in]");
        mon_in2scb.put(trans);
      end
    end
  endtask

endclass
