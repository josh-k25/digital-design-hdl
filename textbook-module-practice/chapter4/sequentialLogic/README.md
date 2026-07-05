# Modules

## asyncResetRegister

Stores one input bit on the rising edge of the clock.

### Testbench

The testbench generates a clock and checks the main behaviors of the register:

- asynchronous reset clears q,
- q captures d on a rising clock edge,
- q holds its previous value between rising edges,
- new data is captured on later rising edges,
- asserting reset between clock edges clears a nonzero value immediately.

The testbench uses @(posedge clk) and @(negedge clk) to synchronize its tests with the generated clock. A short #1 delay is used after clock and reset events so that nonblocking assignments in the DUT can update before the output is checked.

### Running the Testbench

From the asyncResetRegister folder, compile the DUT and testbench together:

```powershell
iverilog -g2012 -s asyncResetRegister_tb -o asyncResetRegister_tb.vvp src\asyncResetRegister.sv testbenches\asyncResetRegister_tb.sv
```

Run the compiled simulation:

```powershell
vvp asyncResetRegister_tb.vvp
```

When all tests pass, the simulation prints:

```powershell
Testing complete.
```

If a test fails, the testbench prints the failed behavior, actual output, expected output, and simulation time.

## sampleHistoryRegister

Implements two 4-bit registers that store the two most recently captured input values.

- current stores the newest captured value.
- previous stores the value that was previously held in current.
- reset asynchronously clears both registers.
- clear synchronously clears both registers.
- capture enables a new value to be stored.
- When capture is low, both registers retain their existing values.

### Testbench

The self-checking testbench generates a 10 ns clock and verifies the main behaviors of the sample history register:

- asynchronous reset immediately clears current and previous,
- the first captured input is stored in current,
- previous receives the old value of current,
- both registers hold their values while capture is disabled,
- clear does not affect the registers until a rising clock edge,
- clear has priority over capture when both controls are asserted.

An error counter records each failed test. The simulation reports whether all tests passed before stopping.

### Running the Testbench

From the sampleHistoryRegister folder, compile the DUT and testbench together:

```powershell
iverilog -g2012 -s sampleHistoryRegister_tb -o sampleHistoryRegister_tb.vvp src\sampleHistoryRegister.sv testbenches\sampleHistoryRegister_tb.sv
```

Run the compiled simulation:

```powershell
vvp sampleHistoryRegister_tb.vvp
```
When all tests pass, the simulation prints:

```powershell
ALL TESTS PASSED
```

If a test fails, the testbench prints the failed behavior, actual outputs, expected outputs, and simulation time.

## threeSampleAnalyzer

Stores the three most recelty capture 4-bit inputs and analyzes them.

- newest stores the most recently caputred input.
- middle stores the previous value of newest.
- oldest stoeres the previous value of middle.
- The registers update together on each rising clock edge using nonblocking assignments.
- reset asynchronously clears all three registers.
- total is the sum of the three stored samples.
- increasing is high when (newest > middle > oldest).
- The combinational calculations use blocking assignments because later calculations depend on earlier intermediate results.

## mooreTurnstile

Implements a Moore finite state machine that controls a turnstile with locked, unlocked, and alarm states.

- S0 represents the locked state.
- S1 represents the unlocked state.
- S2 represents the alarm state.
- Inserting a coin while locked moves the FSM to the unlocked state.
- Pushing while unlocked moves the FSM back to the locked state.
- Pushing while locked moves the FSM to the alarm state.
- The alarm state lasts for one clock cycle before automatically returning to the locked state.
- Inserting a coin while already unlocked keeps the FSM unlocked.
- unlocked and alarm depend only on the current state, making this a Moore FSM.
- reset asynchronously returns the FSM to the locked state.

### Testbench

The self-checking testbench generates a 10 ns clock and verifies the main behaviors of the Moore turnstile FSM:

- asynchronous reset immediately returns the turnstile to the locked state,
- inserting a coin while locked moves the FSM to the unlocked state,
- changing push before a rising edge does not immediately change the outputs,
- pushing while unlocked returns the FSM to the locked state,
- pushing while locked activates the alarm,
- the alarm state automatically returns to the locked state after one clock cycle,
- inserting another coin while already unlocked keeps the FSM unlocked,
- the current state is retained when both inputs are low.

The Moore timing test demonstrates that unlocked and alarm depend only on the current state. Changing an input may change nextstate, but the outputs do not change until the stored state updates on a rising clock edge.

An error counter records each failed test. The simulation reports whether all tests passed before stopping.

### Running the Testbench

From the mooreTurnstile folder, compile the DUT and testbench together:

```powershell
iverilog -g2012 -s mooreTurnstile_tb -o mooreTurnstile_tb.vvp src\mooreTurnstile.sv testbenches\mooreTurnstile_tb.sv
```

Run the compiled simulation:

```powershell
vvp mooreTurnstile_tb.vvp
```

When all tests pass, the simulation prints:

```text
ALL TESTS PASSED
```

If a test fails, the testbench prints the failed behavior, actual outputs, expected outputs, and simulation time.

## mealyVendingMachine

Implements a Mealy finite state machine for a vending machine that dispenses an item after receiving at least 15 cents.

- S0 represents 0 cents of stored credit.
- S1 represents 5 cents of stored credit.
- S2 represents 10 cents of stored credit.
- nickel adds 5 cents to the current credit.
- dime adds 10 cents to the current credit.
- When the total reaches at least 15 cents, dispense becomes high during the same cycle.
- After dispensing, the FSM returns to S0.
- When no coin is inserted, the FSM remains in its current state.
- dispense depends on both the current state and the coin inputs, making this a Mealy FSM.
- reset asynchronously returns the FSM to the 0-cent state.
- The design assumes nickel and dime are not high during the same cycle.

### Testbench

The self-checking testbench generates a 10 ns clock and verifies the main behaviors of the Mealy vending machine FSM:

- asynchronous reset returns the machine to the 0-cent state,
- inserting one nickel stores 5 cents without dispensing,
- inserting one dime stores 10 cents without dispensing,
- a dime inserted while 5 cents are stored causes immediate dispensing,
- a nickel inserted while 10 cents are stored causes immediate dispensing,
- two nickels move the FSM from 0 cents to 5 cents and then to 10 cents,
- a third nickel causes dispensing,
- after dispensing, the FSM returns to the 0-cent state,
- stored credit is retained when no coin is inserted.

The Mealy timing tests check dispense before the next rising clock edge. Because dispense depends on both the current state and the coin inputs, it can become high immediately when the inserted coin raises the total credit to at least 15 cents.

The coin inputs are treated as temporary pulses. After a coin is sampled or used to produce a Mealy output, the corresponding input is returned low so that it is not interpreted as another coin.

An error counter records each failed test. The simulation reports whether all tests passed before stopping.

### Running the Testbench

From the mealyVendingMachine folder, compile the DUT and testbench together:

```powershell
iverilog -g2012 -s mealyVendingMachine_tb -o mealyVendingMachine_tb.vvp src\mealyVendingMachine.sv testbenches\mealyVendingMachine_tb.sv
```

Run the compiled simulation:

```powershell
vvp mealyVendingMachine_tb.vvp
```

When all tests pass, the simulation prints:

```text
ALL TESTS PASSED
```

If a test fails, the testbench prints the failed behavior, actual output, expected output, and simulation time.