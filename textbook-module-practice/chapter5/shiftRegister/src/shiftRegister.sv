module shiftRegister(
    input logic clk,
    input logic reset,
    input logic in,

    output logic [3:0] q
);

always_ff @(posedge clk, posedge reset) begin
    if (reset) 
        q <= 4'b0000;
    else begin
        q[3] <= in;
        q[2] <= q[3];
        q[1] <= q[2];
        q[0] <= q[1];
    end
end

endmodule