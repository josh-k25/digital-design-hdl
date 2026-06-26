module sampleHistoryRegister(
    input logic clk,
    input logic reset,
    input logic clear,
    input logic capture,
    input logic [3:0] d,
    output logic [3:0] current,
    output logic [3:0] previous
);

always_ff @(posedge clk, posedge reset) begin
    if (reset) begin
        current <= 4'b0000;
        previous <= 4'b0000;
    end
    else if (clear) begin
        current <= 4'b0000;
        previous <= 4'b0000;
    end
    else if (capture) begin
        previous <= current;
        current <= d;
    end
end

endmodule