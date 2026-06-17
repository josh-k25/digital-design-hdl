# myFirstModule

This is the first module/test module from Chatper 4 of Digital Design and Comptuer Architecture: RISC-V Edition.

## Description

The module implements a simple combinational logic with three inputs and out output.

```systemverilog
y = (~a & ~b & ~c) |
    ( a & ~b & ~c) |
    ( a & ~b &  c);
```
## Synthesis Result

Vivado synthesized the design into a 3-input lookup table with input buffers and an output buffer.

![Vivado synthesized schematic](images/myFirstFunctionSynthesizedImage.png)