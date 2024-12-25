// This file defines an environment class for a memory module in SystemVerilog.
// The environment class includes instances of the generator, driver, monitors, and scoreboard,
// and sets up the communication between these components using mailboxes.

class environment;

  // Instances of generator, driver, monitors, and scoreboard
  generator gen;
  driver drv;
  monitor_in mon_in;
  monitor_out mon_out;
  scoreboard scb;

  // Mailbox handles for communication
  mailbox gen2drv;
  mailbox mon_in2scb;
  mailbox mon_out2scb;

  // Virtual interface
  virtual mem_if vif;

  // Constructor
  // Initializes the virtual interface, creates mailboxes, and instantiates components
  function new(virtual mem_if vif);
    // Get the interface from the testbench
    this.vif = vif;

    // Create mailboxes
    gen2drv = new();
    mon_in2scb = new();
    mon_out2scb = new();

    // Create instances
    gen = new(gen2drv);
    drv = new(vif, gen2drv);
    mon_in = new(vif, mon_in2scb);
    mon_out = new(vif, mon_out2scb);
    scb = new(mon_in2scb, mon_out2scb);
  endfunction

  // Task for pre-test activities
  // This task performs any necessary setup before the test starts, such as resetting the DUT
  task pre_test();
    drv.reset(); // Reset the DUT
  endtask

  // Task to run the test
  task test();
    fork 
      gen.main();
      drv.main();
      mon_in.main();
      mon_out.main();
      scb.main();
    join_none
  endtask

  // Task for post-test activities
  task post_test();
    // Wait until all generated transactions have been processed by the driver
    wait(gen.repeat_count == drv.num_transactions);
    // Allow time for remaining transactions to be processed
    #100;
    scb.display_summary();
    $finish;
  endtask

  // Run the entire test sequence
  task run();
    pre_test();
    test();
    post_test();
  endtask

endclass
