# Reduction AND Operator

This module is from Chapter 4 of *Digital Design and Computer Architecture: RISC-V Edition*.

## Description

The module uses the SystemVerilog reduction AND operator to combine all eight bits of the input into one output.

```systemverilog
assign y = &a;
```

This is equivalent to: 

```assign y = a[7] & a[6] & a[5] & a[4] &
           a[3] & a[2] & a[1] & a[0];
```

![Vivado synthesized schematic](images/reductionOperatorsSynthesizedImage.png)