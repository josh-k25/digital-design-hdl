
# Sequential Logic Modules

This folder contains SystemVerilog modules created while learning sequential logic from Chapter 4 of *Digital Design and Computer Architecture: RISC-V Edition*.

Sequential logic differs from combinational logic because its outputs can depend on previously stored values. These modules use flip-flops and registers that update on clock edges.

## Modules

### D Flip-Flop

Stores one input bit on the rising edge of the clock.

#### SystemVerilog
```systemverilog
module asyncResetRegister(
    input logic clk,
    input logic reset,
    input logic [3:0] d,
    output logic [3:0] q
);

always_ff @(posedge clk, posedge reset)
    if (reset) q <= 4'b0000;
    else q <= d;

endmodule
```

#### Synthesis Result
![Vivado synthesized schematic](asyncResetRegister/images/asyncResetRegisterSynthImage.png)