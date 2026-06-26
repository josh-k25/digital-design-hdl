module claAdder(
    input logic [3:0] a,
    input logic [3:0] b,
    input logic cin,
    output logic [3:0] sum,
    output logic cout
);

logic [3:0] g;
logic [3:0] p;
logic [4:0] c;


assign p = a | b;
assign g = a & b;

assign c[0] = cin;
assign c[1] = g[0] | (p[0] & c[0]);
assign c[2] = g[1] | p[1] & (g[0] | (p[0] & c[0]));
assign c[3] = g[2] | p[2] & (g[1] | p[1] & (g[0] | (p[0] & c[0])));
assign c[4] = g[3] | p[3] & (g[2] | p[2] & (g[1] | p[1] & (g[0] | (p[0] & c[0]))));

assign sum = a ^ b ^ c[3:0];

assign cout = c[4];

endmodule

