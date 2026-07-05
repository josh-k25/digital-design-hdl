module registerFile(
    input logic clk,
    input logic we,
    input logic [4:0] ra1, ra2,
    input logic [4:0] wa,
    input logic [31:0] wd,

    output logic [31:0] rd1, rd2
);

logic [31:0] rf [31:0];

always_ff @(posedge clk)
    if (we && (wa != 5'b00000)) rf[wa] <= wd;

assign rd1 = (ra1 == 5'b00000) ? 32'b0 : rf[ra1];
assign rd2 = (ra2 == 5'b00000) ? 32'b0 : rf[ra2];

endmodule