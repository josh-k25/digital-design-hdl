
# Modules

## myFirstModule

Implements a combinational Boolean function with three 1-bit inputs and one 1-bit output.

### SystemVerilog

```systemverilog
assign y = (~a & ~b & ~c) |
           ( a & ~b & ~c) |
           ( a & ~b &  c);
```

### reductionOperators 

Uses the SystemVerilog reduction AND operator to combine all eight bits of the input into one output.

### SystemVerilog

```systemverilog
assign y = &a;
```

This is equivalent to:

```systemverilog
assign y = a[7] & a[6] & a[5] & a[4] &
           a[3] & a[2] & a[1] & a[0];
```

## functionSelector

Implements a 4-bit combinational function selector. A 2-bit select input chooses which operation is performed on the two 4-bit inputs, a and b. 

## miniAlu

Implements a 4-bit combinational arithmetic logic unit that performs one of four operations based on a 2-bit operation selector.

- 00 bitwise AND.
- 01 bitwise OR.
- 10  bitwise XOR.
- 11  4-bit addition.
- The output changes whenever an input or the operation selector changes.
- The module does not store any previous values.

### Testbench

The testbench manually applies one test case for each supported operation.

Each test:
- assigns values to a, b, and operation,
- waits 10 ns for the combinational output to update,
- compares result with a manually calculated expected value,
- prints an error message when the output is incorrect.

- The !== case-inequality operator is used so that unknown (x) or high-impedance (z) outputs are also treated as failures.

### Running the Testbench

From the miniAlu folder, compile the DUT and testbench together:

```powershell
iverilog -g2012 -s miniALU_tb -o miniALU_tb.vvp src\miniAlu.sv testbench\miniALU_tb.sv
```

Run the compiled simulation:

```powershell
vvp miniALU_tb.vvp
```

When all tests pass, the simulation prints:

```powershell
Testing complete.
```

If a result is incorrect, the testbench prints the operation, inputs, actual result, and expected result.
