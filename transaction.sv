// This file defines a transaction class for a memory module in SystemVerilog.
// The transaction class includes fields for various signals used in memory operations,
// constraints to control the values of these signals, and a display function for debugging.

class transaction;

  // Declare transaction fields
  rand bit [2:0] addr;        // Address (3 bits)
  rand bit [7:0] wr_data;     // Write data (8 bits)
  rand bit rd_wr;             // Read/Write signal (0: Write, 1: Read)
  bit [7:0] rd_data;          // Read data (captured during read operations)
  rand bit enable;            // Enable signal
  rand bit rst;               // Reset signal

  // Constraint to make enable more often '1' (80% of the time)
  constraint c_enable {
    enable dist {1:=80, 0:=20};
  }

  // Constraint to make reset less frequent (20% of the time)
  constraint c_rst {
    rst dist {1:=20, 0:=80};
  }

  // Display function for debugging
  // This function prints the values of the transaction fields to the console
  function void display(string name);
    $display("------------- %s -------------", name);
    $display("Address: %0d", addr);
    $display("Write Data: %0h", wr_data);
    $display("Read/Write: %0b (0: Write, 1: Read)", rd_wr);
    $display("Read Data: %0h", rd_data);
    $display("Enable: %0b", enable);
    $display("Reset: %0b", rst);
    $display("------------------------------------");
  endfunction

endclass
