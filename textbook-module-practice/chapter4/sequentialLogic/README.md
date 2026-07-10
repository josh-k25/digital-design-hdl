# Modules

Small SystemVerilog practice modules for sequential logic and finite state machines.

## asyncResetRegister

1-bit register with asynchronous reset.

Practiced:

- always_ff
- nonblocking assignments
- rising-edge capture
- asynchronous reset behavior

Tested:

- reset clears q
- q captures d on a rising clock edge
- q holds its value between clock edges
- reset clears immediately, even between clock edges

## sampleHistoryRegister

Stores the two most recent 4-bit input samples.

Practiced:

- multiple registers updating on the same clock edge
- synchronous clear
- capture enable
- using nonblocking assignments for sequential updates

Tested:

- async reset
- first and second captures
- holding values when capture is low
- synchronous clear
- clear priority over capture

## threeSampleAnalyzer

Stores the three most recent 4-bit samples and analyzes them.

Practiced:

- chained register updates
- nonblocking assignments for sample history
- combinational calculations from stored values
- comparing ordered samples

Outputs:

- total: sum of the three stored samples
- increasing: high when newest > middle > oldest

## mooreTurnstile

Moore FSM for a turnstile with locked, unlocked, and alarm states.

Practiced:

- Moore FSM structure
- state register and next-state logic
- outputs based only on current state
- asynchronous reset

States:

- S0: locked
- S1: unlocked
- S2: alarm

Tested:

- coin unlocks the turnstile
- push while unlocked returns to locked
- push while locked triggers alarm
- alarm returns to locked after one cycle
- outputs do not change immediately when inputs change

## mealyVendingMachine

Mealy FSM for a vending machine that dispenses after receiving at least 15 cents.

Practiced:

- Mealy FSM structure
- outputs based on current state and inputs
- temporary input pulses
- state transitions based on coin inputs

States:

- S0: 0 cents
- S1: 5 cents
- S2: 10 cents

Tested:

- nickel and dime transitions
- dispense when credit reaches 15 cents
- immediate Mealy output behavior
- return to S0 after dispensing
- holding credit when no coin is inserted

## Running testbenches

Each module has a self-checking testbench. Compile the DUT and testbench with Icarus Verilog, then run the generated .vvp file.

Example:

```powershell
iverilog -g2012 -s asyncResetRegister_tb -o asyncResetRegister_tb.vvp src\asyncResetRegister.sv testbenches\asyncResetRegister_tb.sv
vvp asyncResetRegister_tb.vvp
```

Passing testbenches print either:

```text
Testing complete.
```

or:

```text
ALL TESTS PASSED
```
