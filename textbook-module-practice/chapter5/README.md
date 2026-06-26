# Modules

## fullAdder

Implements a one-bit full adder.

The module adds three one-bit inputs:

- a
- b
- cin

It produces:

- sum, the least-significant bit of the result
- cout, the carry bit

### SystemVerilog

```systemverilog
module fullAdder(
    input  logic a,
    input  logic b,
    input  logic cin,
    output logic sum,
    output logic cout
);

assign sum  = a ^ b ^ cin;

assign cout = (a & b) | (a & cin) | (b & cin);

endmodule
```

## rippleCarryAdder

Implements a parameterized ripple-carry adder using multiple instances of the fullAdder module.

The default width is 32 bits, but the WIDTH parameter can be changed when the module is instantiated.

Each generated full-adder stage operates on one bit of a and b. The carry output from stage i is connected to the carry input of stage i + 1.

The internal carry bus contains WIDTH + 1 signals:

carry[0] receives the external cin
carry[1] through carry[WIDTH-1] connect adjacent full adders
carry[WIDTH] becomes the final cout

### SystemVerilog

```systemverilog
module rippleCarryAdder #(
    parameter int WIDTH = 32
)(
    input  logic [WIDTH - 1:0] a,
    input  logic [WIDTH - 1:0] b,
    input  logic cin,
    output logic [WIDTH - 1:0] sum,
    output logic cout
);

// Internal carry signals
logic [WIDTH:0] carry;

// Connect external carry-in
assign carry[0] = cin;

genvar i;

generate
    for (i = 0; i < WIDTH; i++) begin : adderStages

         fullAdder fa (
            .a (a[i]),
            .b (b[i]),
            .cin (carry[i]),
            .s (sum[i]),
            .cout (carry[i+1])
        );
    end
endgenerate

// Connect final carry out to cout
assign cout = carry[WIDTH];

endmodule
```

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

This allows the complete result to be compared against {cout, sum}.

### SystemVerilog

```systemverilog
module rippleAdder_tb;

localparam int WIDTH = 32;

logic [WIDTH-1:0] a;
logic [WIDTH-1:0] b;
logic             cin;
logic [WIDTH-1:0] sum;
logic             cout;

logic [WIDTH:0] expected;

rippleCarryAdder #(
    .WIDTH(WIDTH)
) dut (
    .a    (a),
    .b    (b),
    .cin  (cin),
    .sum  (sum),
    .cout (cout)
);

initial begin
    repeat (10000) begin
        a   = $urandom;
        b   = $urandom;
        cin = $urandom_range(0, 1);

        #1;

        expected = {1'b0, a} + {1'b0, b} + cin;

        if ({cout, sum} !== expected) begin
            $fatal( 1, "Mismatch: a=%h b=%h cin=%b, got=%h expected=%h", a, b, cin, {cout, sum}, expected
            );
        end
    end

    $display("All random tests passed.");
    $finish;
end

endmodule
```
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

### Synthesis Result

![Vivado synthesized schematic](rippleAdder/images/rippleAdderSynthImage.png)
