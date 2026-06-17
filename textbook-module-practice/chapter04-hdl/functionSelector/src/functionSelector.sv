module functionSelector(
    input logic [3:0] a,
    input logic [3:0] b,
    input logic [1:0] select,
    output logic [3:0] y);

assign y = 
    (select == 2'b00) ? (a & b) :
    (select == 2'b01) ? (a | b) :
    (select == 2'b10) ? (a ^ b) : 
    {a[1:0], b[1:0]};

endmodule