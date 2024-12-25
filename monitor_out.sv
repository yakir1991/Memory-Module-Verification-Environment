// This file defines a monitor class for the output signals of a memory module in SystemVerilog.
// The monitor class is responsible for sampling the output signals and sending the captured
// transactions to the scoreboard for verification.

`define MON_OUT_IF vif.monitor_out

class monitor_out;

  virtual mem_if vif;  // Virtual interface handle for the memory interface
  mailbox mon_out2scb; // Mailbox to send the transactions to the scoreboard

  // Constructor
  // Initializes the virtual interface and mailbox handle
  function new(virtual mem_if vif, mailbox mon_out2scb);
    this.vif = vif;
    this.mon_out2scb = mon_out2scb;
  endfunction
  
  // Main task to monitor outputs
  task main;
    transaction trans;
    forever begin
      // Wait for enable signal to be active and read operation
      @(posedge `MON_OUT_IF.clk)
      if (`MON_OUT_IF.enable && (`MON_OUT_IF.rd_wr == 1)) begin
        trans = new();
        
        // Wait for the delayed read data
        @(posedge `MON_OUT_IF.clk);
        trans.rd_data = `MON_OUT_IF.rd_data;

        // Display the transaction and send to scoreboard
        trans.display("[Monitor_out]");
        mon_out2scb.put(trans);
      end
    end
  endtask

endclass
