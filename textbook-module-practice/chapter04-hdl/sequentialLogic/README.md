
# Sequential Logic Modules

This folder contains SystemVerilog modules created while learning sequential logic from Chapter 4 of *Digital Design and Computer Architecture: RISC-V Edition*.

Sequential logic differs from combinational logic because its outputs can depend on previously stored values. These modules use flip-flops and registers that update on clock edges.

## Modules

### asyncResetRegister

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

### sampleHistoryRegister

Implements two 4-bit registers that store the two most recently captured input values.

- current stores the newest captured value.
- previous stores the value that was previously held in current.
- reset asynchronously clears both registers.
- clear synchronously clears both registers.
- capture enables a new value to be stored.
- When capture is low, both registers retain their existing values.

#### SystemVerilog

```systemverilog
module sampleHistoryRegister(
    input  logic       clk,
    input  logic       reset,
    input  logic       clear,
    input  logic       capture,
    input  logic [3:0] d,
    output logic [3:0] current,
    output logic [3:0] previous
);

    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            current  <= 4'b0000;
            previous <= 4'b0000;
        end
        else if (clear) begin
            current  <= 4'b0000;
            previous <= 4'b0000;
        end
        else if (capture) begin
            previous <= current;
            current  <= d;
        end
    end

endmodule
```

#### Synthesis Result

![Vivado synthesized schematic](sampleHistoryRegister/images/sampleHistoryRegisterSynthImage.png)

### miniAlu

Implements a 4-bit combinational arithmetic logic unit that performs one of four operations based on a 2-bit operation selector.

- 00 bitwise AND.
- 01 bitwise OR.
- 10  bitwise XOR.
- 11  4-bit addition.
- The output changes whenever an input or the operation selector changes.
- The module does not store any previous values.

#### SystemVerilog

```systemverilog
module miniAlu(
    input  logic [3:0] a,
    input  logic [3:0] b,
    input  logic [1:0] operation,
    output logic [3:0] result
);

    always_comb begin
        case (operation)
            2'b00: result = a & b;
            2'b01: result = a | b;
            2'b10: result = a ^ b;
            2'b11: result = a + b;
            default: result = 4'b0000;
        endcase
    end

endmodule
```
#### Synthesis Result

![Vivado synthesized schematic](miniAlu/images/miniAluSynthImage.png)