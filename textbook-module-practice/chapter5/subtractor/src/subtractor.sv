module subtractor #(
    parameter int WIDTH = 4
)(
    input logic [WIDTH - 1:0] a,
    input logic [WIDTH - 1:0] b, 
    output logic [WIDTH - 1:0] difference
);

assign difference = a + (~b) + 1;

endmodule