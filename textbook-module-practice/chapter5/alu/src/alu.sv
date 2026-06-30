module alu (
    input logic [3:0] a,
    input logic [3:0] b,
    input logic [1:0] aluControl,
    
    output logic [3:0] result,
    
    // negative flag
    output logic N,
    // zero flag
    output logic Z,
    // carry flag 
    output logic C,
    // overflow flag
    output logic V
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

assign Z = ~(|result);
assign N = result[3];
assign C = arithmeticCout & ((aluControl == 2'b00) || (aluControl == 2'b01));
assign V = 
        (((a[3] & b[3] & ~arithmeticResult[3]) | (~a[3] & ~b[3] & arithmeticResult[3])) & (aluControl == 2'b00))
        | (((~a[3] & b[3] & arithmeticResult[3]) | (a[3] & ~b[3] & ~arithmeticResult[3])) & (aluControl == 2'b01)); 

endmodule