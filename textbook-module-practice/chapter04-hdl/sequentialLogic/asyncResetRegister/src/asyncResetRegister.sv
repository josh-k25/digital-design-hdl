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