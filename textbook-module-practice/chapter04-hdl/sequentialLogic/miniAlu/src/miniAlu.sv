module miniAlu(
    input logic [3:0] a,
    input logic [3:0] b,
    input logic [1:0] operation,
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
