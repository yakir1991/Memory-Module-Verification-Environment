// This file defines a generator class for a memory module in SystemVerilog.
// The generator class is responsible for creating and sending transactions to the driver.

class generator;

  // Declare a transaction object
  rand transaction trans;
  
  // Repeat count indicates the number of transactions to generate
  int repeat_count;
  
  // Mailbox to send the transactions to the driver
  mailbox gen2drv;
  
  // Constructor
  // The constructor initializes the mailbox handle
  function new(mailbox gen2drv);
    // Get the mailbox handle from the environment 
    this.gen2drv = gen2drv;
  endfunction
  
  // Main task to generate transactions and send them to the driver
  task main();
    repeat (repeat_count) begin
      trans = new();
      
      // Randomize the transaction and ensure that it includes ALU operations
      if (!trans.randomize()) begin
        $fatal("Generator: Transaction randomization failed!");
      end
      
      // Display the transaction for debugging
      trans.display("[Generator]");
      
      // Send the transaction to the driver via the mailbox
      gen2drv.put(trans); 
    end
    $display("[Generator] Completed generating %0d transactions.", repeat_count);
  endtask

endclass
