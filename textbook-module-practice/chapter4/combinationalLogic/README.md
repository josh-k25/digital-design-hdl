# Modules

Small SystemVerilog practice modules from early digital design work.

## myFirstModule

Combinational Boolean function with three 1-bit inputs and one 1-bit output.

Practiced:

- basic assign statements
- bitwise NOT, AND, and OR
- writing a Boolean equation directly in SystemVerilog

## reductionOperators

Uses the SystemVerilog reduction AND operator to reduce an 8-bit input into one output bit.

Practiced:

- reduction operators
- compact multi-bit logic expressions

Example:

```systemverilog
assign y = &a;
```

This is equivalent to ANDing every bit of `a` together.

## functionSelector

4-bit combinational function selector. A 2-bit select signal chooses which operation is applied to the two 4-bit inputs.

Practiced:

* combinational selection logic
* using a control signal to choose between operations

## miniAlu

4-bit combinational ALU with four operations selected by a 2-bit control input.

Operations:

- 00: bitwise AND
- 01: bitwise OR
- 10: bitwise XOR
- 11: 4-bit addition

Practiced:

- basic ALU structure
- combinational case logic
- testing one operation at a time

## Testing

The miniAlu testbench applies one test case for each supported operation and checks the result against the expected value.

Run from the miniAlu folder:

```powershell
iverilog -g2012 -s miniALU_tb -o miniALU_tb.vvp src\miniAlu.sv testbench\miniALU_tb.sv
vvp miniALU_tb.vvp
```

Expected output:

```powershell
Testing complete.
```
