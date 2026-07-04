module instructionMemory#(
    parameter int DEPTH = 32,
    parameter int WIDTH = 32,
    parameter string fileName = "program.hex")(
    input logic [$clog2(DEPTH)-1:0] address,
    
    output logic [WIDTH-1:0] rd
);

logic [WIDTH-1:0] memory[0:DEPTH-1];

initial 
    $readmemh(fileName, memory);

assign rd = memory[address];

endmodule