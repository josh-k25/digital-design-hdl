module threeSampleAnalyzer(
    input logic clk,
    input logic reset,
    input logic [3:0] d,

    output logic [3:0] newest,
    output logic [3:0] middle,
    output logic [3:0] oldest,
    /* Since the sum of 3 inputs of 4 bits wide can 
    add up to 45 the total needs to be 6 bits wide */ 
    output logic [5:0] total,
    output logic increasing
);

    logic [5:0] partialSum;

always_ff @(posedge clk, posedge reset) begin
    if (reset) begin
        newest <= 4'b0000;
        middle <= 4'b0000;
        oldest <= 4'b0000; 
    end
    else begin
    newest <= d;
    middle <= newest;
    oldest <= newest; 
    end
end 

always_comb begin
    partialSum = newest + middle;
    total = partialSum + oldest;

    increasing = ((newest > middle) && (middle > oldest));
    end
endmodule



