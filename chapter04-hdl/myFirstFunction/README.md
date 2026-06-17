# myFirstModule

This is the first module/test module from Chatper 4 of Digital Design and Comptuer Architecture: RISC-V Edition.

## Description

The module implements a simple combinational logic with three inputs and out output.

```systemverilog
y = (~a & ~b & ~c) |
    ( a & ~b & ~c) |
    ( a & ~b &  c);
```

![Vivado synthesized schematic](images/myFirstFunctionSynthesizedImage.png)