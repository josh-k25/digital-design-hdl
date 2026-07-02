module alu (
    input logic [3:0] a,
    input logic [3:0] b,
    input logic [2:0] aluControl,
    
    output logic [3:0] result,
    
    // negative flag
    output logic N,
    // zero flag
    output logic Z,
    // carry flag 
    output logic C,
    // overflow flag
    output logic V,

    // set less than 
    output logic lessThan,

    output logic lessThanUnsigned
);

logic subtract;
logic [3:0] modifiedB;
logic [3:0] arithmeticResult;
logic arithmeticCout;
logic arithmeticOverflow;

output logic SLT;
output logic SLTU;

//subtract being high generates a cin which is the + 1 for twos compliment in the subtraction
assign subtract  = (aluControl == 3'b001) | (aluControl == 3'b101) | (aluControl == 3'b110);
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
        3'b000: result = arithmeticResult;
        3'b001: result = arithmeticResult;
        3'b010: result = a & b;
        3'b011: result = a | b;
        3'b101: result = {3'b000, };
        3'b110: result = {3'b000, ~C};
        default: result = 4'b0000;
    endcase
end

assign Z = ~(|result);
assign N = result[3];
assign C = arithmeticCout & ((aluControl == 3'b000) || (aluControl == 3'b001));
assign V = 
        (((a[3] & b[3] & ~arithmeticResult[3]) | (~a[3] & ~b[3] & arithmeticResult[3])) & (aluControl == 3'b000))
        | (((~a[3] & b[3] & arithmeticResult[3]) | (a[3] & ~b[3] & ~arithmeticResult[3])) & (aluControl == 3'b001)); 

assign SLT = arithmeticResult[3] ^ V;
assign SLTU = ~C;
endmodule