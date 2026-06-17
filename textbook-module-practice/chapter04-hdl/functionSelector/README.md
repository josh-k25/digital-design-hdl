# functionSelector

This module was created while working through Chapter 4 of *Digital Design and Computer Architecture: RISC-V Edition*.

## Description

The module implements a 4-bit combinational function selector.

A 2-bit select input chooses which operation is performed on the two 4-bit inputs, `a` and `b`.

## SystemVerilog

```systemverilog
module functionSelector(
    input  logic [3:0] a,
    input  logic [3:0] b,
    input  logic [1:0] select,
    output logic [3:0] y
);

    assign y =
        (select == 2'b00) ? (a & b) :
        (select == 2'b01) ? (a | b) :
        (select == 2'b10) ? (a ^ b) :
                           {a[1:0], b[1:0]};

endmodule
```

## Synthesized Design
![Vivado synthesized schematic](images/functionSelectorSynthesizedImage.png)
