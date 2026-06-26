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