module comparator #(
    parameter int WIDTH = 4
)(
    input logic [WIDTH - 1:0] a,
    input logic [WIDTH - 1:0] b,
    output logic equal,
    output logic lessThan,
    output logic greaterThan
);

assign equal = a == b;
assign lessThan = a < b;
assign greaterThan = a > b;

endmodule

