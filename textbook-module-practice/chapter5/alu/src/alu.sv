module alu (
    input logic [3:0] a,
    input logic [3:0] b,
    input logic [1:0] aluControl,
    output logic [3:0] result
);

logic subtract;
logic [3:0] modifiedB;
logic [3:0] arithmeticResult;
logic arithmeticCout;

assign subtract  = (aluControl == 2'b01);
assign modifiedB = b ^ {4{subtract}};

claAdder arithmeticUnit (
    .a (a),
    .b (modifiedB),
    .cin (subtract),
    .sum (arithmeticResult),
    .cout (arithmeticCout)
);

always_comb begin
    case (aluControl)
        2'b00: result = arithmeticResult;
        2'b01: result = arithmeticResult;
        2'b10: result = a & b;
        2'b11: result = a | b;
        default: result = 4'b0000;
    endcase
end

endmodule