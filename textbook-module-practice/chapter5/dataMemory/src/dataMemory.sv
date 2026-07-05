module dataMemory#(
    parameter int DEPTH = 8
)(
    input logic clk, we,
    input logic [$clog2(DEPTH)-1:0] address,
    input logic [31:0] wd,
    
    output logic [31:0] rd
);

logic [31:0] memory[DEPTH-1:0];

assign rd = memory[address];

always_ff @(posedge clk)
    if (we)
        memory[address] <= wd;
endmodule