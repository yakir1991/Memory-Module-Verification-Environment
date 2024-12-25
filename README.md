# Memory Module Verification Environment

This project provides a comprehensive verification environment for a memory module using SystemVerilog. The environment includes various components such as a generator, driver, monitors, scoreboard, and direct tests to ensure the correctness and functionality of the memory module.

## Project Structure

- **interface.sv**: Defines the memory interface with modports for different components.
- **transaction.sv**: Defines the transaction class used for memory operations, including constraints and a display function.
- **generator.sv**: Responsible for creating and sending transactions to the driver.
- **driver.sv**: Receives transactions from the generator and drives the corresponding signals to the memory interface.
- **monitor_in.sv**: Monitors the input signals of the memory module and sends captured transactions to the scoreboard.
- **monitor_out.sv**: Monitors the output signals of the memory module and sends captured transactions to the scoreboard.
- **scoreboard.sv**: Verifies the correctness of memory operations by comparing the expected memory state with the actual transactions.
- **environment.sv**: Sets up the verification environment, including instances of the generator, driver, monitors, and scoreboard.
- **test.sv**: Defines a test program that creates the environment, sets the number of transactions to generate, and runs the environment.
- **testbench.sv**: The top-level testbench module that includes clock generation, VCD dump for waveform viewing, and instantiation of the interface, test program, and Device Under Test (DUT).
- **direct_test.sv**: Defines direct tests for the memory module, including specific test sequences to verify functionality.

## Author

The verification environment was created by Yakir Aqua.

## How to Run

1. Clone the repository:
    ```bash
    git clone https://github.com/USERNAME/REPOSITORY_NAME.git](https://github.com/yakir1991/Memory-Module-Verification-Environment.git
    cd REPOSITORY_NAME
    ```

2. Compile and run the testbench using your preferred SystemVerilog simulator.

3. View the generated waveform using a waveform viewer to analyze the results.

