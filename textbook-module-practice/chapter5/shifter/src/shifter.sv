module shifter(
    input logic [31:0] num,
    input logic [1:0] shiftType,
    input logic [4:0] shiftAmount,  

    output logic [31:0] result
);

always_comb begin
    case(shiftType)
        2'b00: result = num << shiftAmount;
        2'b01: result = num >> shiftAmount;
        2'b10: result = $signed(num) >>> shiftAmount;
        2'b11: result = num;
    endcase
end

endmodule