# Modules

## fullAdder

One-bit full adder with inputs a, b, and cin.

Outputs:

- s: sum
- cout: carry out

Practiced basic combinational arithmetic.

## rippleAdder

Parameterized ripple-carry adder built from multiple fullAdder instances.

Practiced:

- structural module instantiation
- parameterized widths
- generate loops
- carry propagation

The testbench applies 10,000 random input combinations and compares {cout, sum} against the expected result.

## claAdder

Four-bit carry-lookahead adder.

Practiced:

- generate and propagate signals
- expanded carry equations
- calculating carries in parallel
- exhaustive combinational testing

The testbench checks all 512 possible combinations of a, b, and cin.

## subtractor

Parameterized subtractor using two’s-complement addition:

```text
a - b = a + (~b) + 1
```

Practiced:

- two’s-complement subtraction
- fixed-width arithmetic
- wraparound behavior

## unsignedComparator

Parameterized unsigned comparator.

Outputs:

- equal
- lessThan
- greaterThan

Practiced unsigned comparisons and mutually exclusive outputs.

## alu

Four-bit arithmetic logic unit.

Supported operations:

- addition
- subtraction
- bitwise AND
- bitwise OR
- signed set-less-than
- unsigned set-less-than

Status flags:

- N: negative
- Z: zero
- C: carry
- V: signed overflow

Practiced:

- sharing adder hardware between operations
- two’s-complement subtraction
- signed and unsigned comparisons
- carry and overflow detection
- combinational control logic

The testbench checks every operation along with important carry, zero, negative, overflow, and comparison cases.

## shifter

Thirty-two-bit combinational shifter.

Supported operations:

- logical left shift
- logical right shift
- arithmetic right shift
- no shift

Practiced:

- logical and arithmetic shifts
- signed casting
- variable shift amounts
- boundary cases such as shifts by 0 and 31

## shiftRegister

Four-bit serial-in shift register with asynchronous reset.

Practiced:

- sequential shifting
- nonblocking assignments
- simultaneous register updates
- asynchronous reset

The testbench shifts a known bit sequence and checks the stored value after each clock edge.

## registerFile

Register file containing 32 registers of 32 bits each.

Features:

- two asynchronous read ports
- one synchronous write port
- write enable
- register x0 hardwired to zero

Practiced:

- multiport memories
- synchronous writes
- asynchronous reads
- special register behavior

The testbench checks reads, writes, disabled writes, and protection of register zero.

## instructionMemory

Parameterized read-only instruction memory initialized from a hexadecimal file.

Practiced:

- memory arrays
- $readmemh
- parameterized depth and width
- asynchronous reads
- $clog2 for address sizing

The testbench checks values at the beginning, middle, and end of the initialized memory.

## dataMemory

Parameterized data memory containing 32-bit words.

Features:

- asynchronous reads
- synchronous writes
- write enable
- configurable depth

Practiced:

- memory read/write timing
- retaining data when writes are disabled
- independent memory locations
- parameterized address widths

The testbench checks enabled and disabled writes, multiple addresses, and the final valid address.

## Running the testbenches

Each module folder contains its source and self-checking testbench.

General compile format:

```powershell
iverilog -g2012 -s <module>_tb -o <module>_tb src\<module>.sv testbenches\<module>_tb.sv
```

Run the simulation:

```powershell
vvp <module>_tb
```

Some modules depend on another source file, such as `rippleAdder` using `fullAdder` or the ALU using `claAdder`. Include those files in the compile command when required.
