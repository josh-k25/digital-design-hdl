# Modules

## fullAdder

Implements a one-bit full adder.

The module adds three one-bit inputs:

- a
- b
- cin

It produces:

- s, the one-bit sum output
- cout, the carry bit

## rippleAdder

Implements a parameterized ripple-carry adder using multiple instances of the fullAdder module.

The default width is 32 bits, but the WIDTH parameter can be changed when the module is instantiated.

Each generated full-adder stage operates on one bit of a and b. The carry output from stage i is connected to the carry input of stage i + 1.

The internal carry bus contains WIDTH + 1 signals:

carry[0] receives the external cin
carry[1] through carry[WIDTH-1] connect adjacent full adders
carry[WIDTH] becomes the final cout

### Testbench

The testbench instantiates the ripple carry adder and applies 10000 random sample input values to verify its basic operation.

For each test it:

- generates random values for a and b,
- randomly selects cin to 0 or 1,
- calculatioes the expected result with SystemVerilog addition,
- compares the expected result with {cout, sum} (concatenation)

The operands are extended by one bit before addition to preseve the final carry bit:

### SystemVerilog

```systemverilog
expected = {1'b0, a} + {1'b0, b} + cin;
```

This allows the complete result to be compared against {cout, sum}.

### Running the Testbench

From the rippleAdder folder, compile the full adder, ripple-carry adder, and testbench together:

```powershell
iverilog -g2012 -s rippleAdder_tb -o rippleAdder_tb.vvp src\fullAdder.sv src\rippleAdder.sv testbenches\rippleAdder_tb.sv
```

Run the compiled simulation:

```powershell
vvp rippleAdder_tb.vvp
```

When all tests pass, the simulation prints:

```powershell
All random tests passed.
```

If a test fails, the testbench prints the values of a, b, and cin, along with the actual and expected results.

## claAdder

Implements a four-bit carry-lookahead adder.

The module calculates generate and propagate signals for each bit:

- g[i] indicates that bit i generates a carry on its own
- p[i] indicates that bit i propagates an incoming carry

Unlike a ripple-carry adder, each carry equation is expanded so that it does not depend directly on the previous carry signal. This allows the carry signals to be calculated in parallel from the generate signals, propagate signals, and cin.

The internal carry bus contains five signals:

c[0] receives the external cin  
c[1] through c[3] are the carry inputs for the remaining bit positions  
c[4] becomes the final cout

Each sum bit is calculated using its corresponding carry input.

### Testbench

The testbench instantiates the carry-lookahead adder and exhaustively tests every possible input combination.

The four-bit inputs a and b each have 16 possible values, while cin has two possible values. This gives:

16 × 16 × 2 = 512

total test cases.

Three nested loops are used to test every combination of a, b, and cin.

For each test it:

- assigns the current loop values to a, b, and cin,
- waits for the combinational logic to settle,
- calculates the expected result with SystemVerilog addition,
- compares the expected result with {cout, sum}.

The operands are extended by one bit before addition to preserve the final carry bit:

```systemverilog
expected = {1'b0, a} + {1'b0, b} + cin;
```

This allows the complete result to be compared to {cout, sum} (concatenation).

### Running the Testbench

From the claAdder folder, compile the carry-lookahead adder and testbench together:

```powershell
iverilog -g2012 -s claAdder_tb -o claAdder_tb.vvp src/claAdder.sv testbenches/claAdder_tb.sv
```

Run the compiled simulation:

```powershell
vvp claAdder_tb.vvp
```

When all tests pass, the following is printed:

```powershell
All CLA tests passed.
```

If a test fails, the testbench prints the values of a, b, and cin, along with the actual and expected results.


## subtractor

Implements a parameterized subtractor using two’s complement addition.

The default width is four bits, but the WIDTH parameter can be changed when the module is instantiated.

Subtraction is performed using:

```systemverilog
a - b = a + (~b) + 1
```

The bits of b are inverted and one is added to form the two’s complement of b. This value is then added to a.

The difference output contains WIDTH bits. If the mathematical result does not fit within WIDTH bits, the result wraps around and only the lowest WIDTH bits are retained.

For example, with WIDTH = 4:

```text
3 - 5 = 0011 - 0101 = 1110
```

The bit pattern 1110 represents -2 when interpreted as a four-bit signed two’s complement number.

### Running the Testbench

From the subtractor folder, compile the subtractor and testbench together:

```powershell
iverilog -g2012 -s subtractor_tb -o subtractor_tb.vvp src/subtractor.sv testbenches/subtractor_tb.sv
```

Run the compiled simulation:

```powershell
vvp subtractor_tb.vvp
```

When all tests pass, the following is printed:

```powershell
All subtractor tests passed.
```

If a test fails, the simulation stops and prints the values of a and b, along with the actual and expected differences.

## unsignedComparator

Implements a parameterized unsigned magnitude comparator.

The default width is four bits, but the WIDTH parameter can be changed when the module is instantiated.

The module compares two unsigned WIDTH-bit inputs and produces three outputs:

- equal is 1 when a and b have the same value,
- lessThan is 1 when a is less than b,
- greaterThan is 1 when a is greater than b.

Exactly one comparison output should be 1 for every valid combination of a and b.

Because a and b are declared without the signed keyword, the comparison operators interpret them as unsigned values.

## alu

Implements a 4-bit arithmetic logic unit.

The operation is selected using the three-bit `aluControl` input:

- 000 = addition
- 001 = subtraction
- 010 = bitwise AND
- 011 = bitwise OR
- 101 = signed set less than
- 110 = unsigned set less than
- other = output zero

Addition and subtraction share the same 4-bit cla:

For addition:

```text
modifiedB = b
cin = 0
```

For subtraction:

```text
modifiedB = ~b
cin = 1
```

This implements:

```text
a - b = a + (~b) + 1
```

The subtract control signal is also used for signed and unsigned set less than operations because both comparisons are based on subtraction.

### Status Flags

The ALU produces four status flags:

- N: negative flag
- Z: zero flag
- C: carry flag
- V:  signed overflow flag

#### Negative Flag

N copies the MSB of the result:

```systemverilog
assign N = result[3];
```

For a signed two’s complement result, an MSB of 1 usually indicates a negative value (unless there is overflow).

#### Zero Flag

Z is 1 when every result bit is zero:

```systemverilog
assign Z = ~(|result);
```

The reduction OR produces 1 when any result bit is high. Inverting it produces one only when all result bits are zero.

#### Carry Flag

C uses the carry output from the arithmetic unit during addition and subtraction.

#### Overflow Flag

V detects signed arithmetic overflow.

Addition overflow occurs when:

- two positive operands produce a negative-looking result
or
- two negative operands produce a positive-looking result

Subtraction overflow occurs when operands with different signs produce a result with an invalid sign(out of range of the signed bits).

### Set-Less-Than Operations

Signed set less than cannot use the sign bit of a - b since with subraction overflow, the sign bit is refersed from the signed comparison result.

The signed comparison therefore uses:

```systemverilog
lessThan = arithmeticResult[3] ^ arithmeticOverflow;
```

Unsigned set-less-than uses the carry output from subtraction:

```systemverilog
lessThanUnsigned = ~arithmeticCout;
```
When the comparison is true, the ALU output is:

```text
0001
```

Otherwise, the output is:

```text
0000
```

### Testbench

The testbench checks:

- addition
- subtraction
- bitwise AND
- bitwise OR
- zero flag assertion
- negative flag assertion
- carry generation
- arithmetic without carry
- positive addition overflow
- negative addition overflow
- positive minus negative subtraction overflow
- negative minus positive subtraction overflow
- non overflowing addition
- non overflowing subtraction
- signed set less than
- unsigned set less than

### Running the Testbench

From the alu folder, compile the cla, ALU, and testbench:

```powershell
iverilog -g2012 -s alu_tb -o alu_tb ..\claAdder\src\claAdder.sv src\alu.sv testbenches\alu_tb.sv
```

Run the simulation:

```powershell
vvp alu_tb
```

When all tests pass, the simulation prints:

```text
All ALU tests with flags passed.
```

## shifter

Implements a 32-bit combinational shifter.

The module receives:

- num, the value to shift
- shiftType, the operation selector
- shiftAmount, the shift distance
- result, the shifted output

shiftAmount is 5 bits to represent shift distances from 0 to 31.

shiftType operations:
- 00: logical left shift
- 01: logical right shift
- 10: arithmetic right shift
- 11: no shift

The arithmetic left shift is not needed as since it behaves the same as logical left shift.

### Logical Left Shift

A logical left shift moves bits toward the MSB and fills the new position with 0s.

Bits shifted beyond the 32-bit output width are discarded.

### Logical Right Shift

A logical right shift moves bits toward the LSB and fills the new position with 0s.

### Arithmetic Right Shift

An arithmetic right shift preserves the sign of a signed two’s complement value.

The original MSB is copied into the new upper positions.

Because num is declared as an unsigned logic vector, it is cast to a signed value before applying the arithmetic right-shift operator:

### Testbench

The testbench verifies:

- logical left shift by 0
- logical left shift by 1
- logical left shift by 31
- logical right shift by 0
- logical right shift by 1
- logical right shift by 31
- arithmetic right shift with a most-significant bit of one
- arithmetic right shift with a most-significant bit of zero

Testing a shift amount of zero verifies that the input passes through unchanged.

Testing a shift amount of 31 checks the largest value representable by `shiftAmount`.

The arithmetic shift tests verify that upper positions are filled using the sign bit rather than always being filled with zero.

### Running the Testbench

From the `shifter` folder, compile the shifter and testbench:

```powershell
iverilog -g2012 -s shifter_tb -o shifter_tb src\shifter.sv testbenches\shifter_tb.sv
```

Run the simulation:

```powershell
vvp shifter_tb
```
When all tests pass, the following is printed:

```powershell
All tests passed.
```

## shiftRegister

Implements a four-bit serial in shift register.

The module has:

- clk, the clock input
- reset, an asynchronous active-high reset
- in, the serial input
- q, the four-bit stored output

On each rising clock edge:

- the new value of in is stored in q[3]
- the previous value of q[3] moves into q[2]
- the previous value of q[2] moves into q[1]
- the previous value of q[1] moves into q[0]
- the previous value of q[0] is shifted out

Nonblocking assignments are used so that all four ffs update together after the clock edge.

Each right hand side is evaluated using the values that existed immediately before the edge.

When reset is asserted, q is immediately cleared without waiting for a clock edge.

### Testbench

The testbench:

- initializes the clock
- asserts the asynchronous reset
- shifts the pattern 1, 0, 1, 1, and 0
- checks q after each rising edge
- asserts reset again
- verifies that q immediately becomes zero

### Running the Testbench

From the shiftRegister folder, compile the shift register and testbench:

```powershell
iverilog -g2012 -s shiftRegister_tb -o shiftRegister_tb src\shiftRegister.sv testbenches\shiftRegister_tb.sv
```

Run the simulation:

```powershell
vvp shiftRegister_tb
```

When all tests pass, the simulation prints:

```text
All tests passed.
```

## registerFile

Implements a register file containing 32 registers.

Each register stores a 32-bit value.

The register file has:

- two asynchronous read ports
- one synchronous write port
- one write-enable input
- special handling for register zero

The 5-bit addresses can select one of 32 registers.

### Asynchronous Reads

The two read ports operate independently:

```systemverilog
assign rd1 = (ra1 == 5'b00000) ? 32'b0 : rf[ra1];
assign rd2 = (ra2 == 5'b00000) ? 32'b0 : rf[ra2];
```
Changing either read address immediately changes its corresponding read data output.

This allows two source registers to be read in parallel.

### Synchronous Writes

Writing occurs on the rising edge of clk when we is asserted:

```systemverilog
always_ff @(posedge clk)
    if (we && (wa != 5'b00000))
        rf[wa] <= wd;
```

### Register Zero

Register zero is hardwired to zero.

The module enforces this behavior in two ways:

- writes to address zero are ignored
- reads from address zero always return 32'b0

### Testbench

The testbench verifies:

- writing a value to register 1
- reading register 1 through the first read port
- writing a value to register 2
- reading register 2 through the second read port
- preventing writes to register zero
- returning zero when register zero is read
- preventing writes while we is zero
- preserving stored values while writing is disabled

### Running the Testbench

From the registerFile folder, compile the register file and testbench:

```powershell
iverilog -g2012 -s registerFile_tb -o registerFile_tb src\registerFile.sv testbenches\registerFile_tb.sv
```

Run the simulation:

```powershell
vvp registerFile_tb
```

When all tests pass, the simulation prints:

```text
All tests passed.
```

## instructionMemory

Implements a parameterized read-only instruction memory.

The module has three parameters:
- DEPTH: defaults to 32 stored words
- WIDTH: defaults to 32 bits per word
- fileName: "program.hex" (initialization file naem)

The address bit width is calculated using:

```systemverilog
$clog2(DEPTH)
```

This produces enough address bits to select one of the configured memory locations.

The memory is initialized at the beginning of simulation using:

```systemverilog
$readmemh(fileName, memory);
```

Each line of the hexadecimal file initializes one memory word.
The first line initializes address zero. Later lines initialize consecutively increasing addresses.

The read operation is asynchronous:

```systemverilog
assign rd = memory[address];
```

Changing address immediately selects another memory word.

There is no clock because the module does not support runtime writes.

### Initialization File

The testbench uses the following program.hex file:

```text
00000000
11111111
22222222
33333333
A5A5A5A5
5A5A5A5A
DEADBEEF
CAFEBABE
```
### Testbench

The testbench creates an instruction memory with:

DEPTH = 8
WIDTH = 32

It verifies:

- the first entry at address zero
- a middle entry at address four
- the final entry at address seven

These checks confirm that:

- the hexadecimal file was loaded
- values were loaded in the expected order
- asynchronous addressing selects the correct word

### Running the Testbench

From the instructionMemory folder, compile the instruction memory and testbench:

```powershell
iverilog -g2012 -s instructionMemory_tb -o instructionMemory_tb src\instructionMemory.sv testbenches\instructionMemory_tb.sv
```

Run the simulation from the directory containing program.hexz:

```powershell
vvp instructionMemory_tb
```

When all tests pass, the simulation prints:

```text
All tests passed
```
## dataMemory

Implements a parameterized data memory containing 32-bit words.

The default depth is eight words, but the DEPTH parameter can be changed when the module is instantiated.

The address width is calculated using:

```systemverilog
$clog2(DEPTH)
```

The memory has:

- one address port
- one 32-bit write-data input
- one 32-bit read-data output
- one write-enable input
- one clock input

The read operation is asynchronous:

```systemverilog
assign rd = memory[address];
```
Changing `address` immediately changes `rd` to the contents of the selected memory location.

Writes occur on the rising edge of `clk`:

```systemverilog
always_ff @(posedge clk)
    if (we)
        memory[address] <= wd;
```
A write occurs only when we is asserted.
When we is zero, the selected memory word retains its previous value.

### Testbench

The testbench verifies:

- writing data on a rising edge
- retaining the old value before the next rising edge
- changing the stored value only after an enabled clock edge
- preventing writes when `we` is zero
- storing independent values at different addresses
- reading previously written values
- writing and reading the final valid address

The testbench first stores:

```text
88888888
```

at address zero.

It then changes wd and verifies that the stored value does not change until the next rising edge.

It also writes different values to separate addresses and confirms that one memory location does not overwrite another.

### Running the Testbench

From the dataMemory folder, compile the memory and testbench:

```powershell
iverilog -g2012 -s dataMemory_tb -o dataMemory_tb src\dataMemory.sv testbenches\dataMemory_tb.sv
```

Run the simulation:

```powershell
vvp dataMemory_tb
```

When all tests pass, the simulation prints:

```text
All tests passed.
```
