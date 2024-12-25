// This file defines a scoreboard class for a memory module in SystemVerilog.
// The scoreboard class is responsible for verifying the correctness of the memory operations
// by comparing the expected memory state with the actual transactions captured by the monitors.

class scoreboard;

  int num_passed, num_failed, num_transactions; // Counters for passed, failed, and total transactions
  bit [7:0] mem_expected [0:7];  // Expected memory state

  mailbox mon_in2scb, mon_out2scb; // Mailboxes to receive transactions from input and output monitors

  // Constructor
  // Initializes the mailboxes and counters, and sets the initial expected memory state
  function new(mailbox mon_in2scb, mailbox mon_out2scb);
    this.mon_in2scb = mon_in2scb;
    this.mon_out2scb = mon_out2scb;
    num_passed = 0;
    num_failed = 0;
    num_transactions = 0;
    // Initialize expected memory state to 'hFF
    for (int i = 0; i < 8; i++) mem_expected[i] = 8'hFF;
  endfunction

  // Function to print the expected memory state
  function void print_mem_expected();
    $display("[Scoreboard] Expected Memory State:");
    for (int i = 0; i < 8; i++) $display("  Address %0d: Data = %0h", i, mem_expected[i]);
  endfunction

  // Main task to compare the transactions
  task main;
    transaction in_trans, out_trans;
    
    forever begin
      // Get transaction from input monitor
      mon_in2scb.get(in_trans);
      
      if (in_trans.rst) begin 
        // Reset the expected memory state on reset transaction
        for (int i = 0; i < 8; i++) begin
          mem_expected[i] = 8'hFF;
        end
        $display("[Scoreboard] Reset: Memory state reset.");
      end else begin
        if (in_trans.rd_wr == 0) begin  // Write operation
          // Update expected memory state
          mem_expected[in_trans.addr] = in_trans.wr_data;
          $display("[Scoreboard] Write: Address=%0d, Data=%0h", in_trans.addr, in_trans.wr_data);
          print_mem_expected();
        end else if (in_trans.rd_wr == 1) begin  // Read operation
          // Get transaction from output monitor
          mon_out2scb.get(out_trans);
          $display("[Scoreboard] Read: Address=%0d", in_trans.addr);
          print_mem_expected();
          // Compare the read data with expected data
          if (out_trans.rd_data == mem_expected[in_trans.addr]) begin
            $display("[Scoreboard] PASS: Address=%0d, Expected=%0h, Actual=%0h",
                     in_trans.addr, mem_expected[in_trans.addr], out_trans.rd_data);
            num_passed++;
          end else begin
            $display("[Scoreboard] FAIL: Address=%0d, Expected=%0h, Actual=%0h",
                     in_trans.addr, mem_expected[in_trans.addr], out_trans.rd_data);
            num_failed++;
          end
        end
      end
      num_transactions++;
    end
  endtask

  // Function to display test summary
  function void display_summary();
    $display("[Scoreboard] Passed: %0d, Failed: %0d, Transactions: %0d", num_passed, num_failed, num_transactions);
  endfunction

endclass
