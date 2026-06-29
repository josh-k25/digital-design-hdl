module aluNoFlags_tb;

logic [3:0] a;
logic [3:0] b;
logic [1:0] aluControl;
logic [3:0] result;

alu dut (
    .a (a),
    .b (b),
    .aluControl (aluControl),
    .result (result)
);

initial begin
    //add: 2 + 3 = 5
    a = 4'b0010;
    b = 4'b0011;
    aluControl = 2'b00;
    #1;

    if (result !== 4'b0101)
        $fatal(1, "ADD failed: got %b", result);

    //subtract: 5 - 3 = 2
    a = 4'b0101;
    b = 4'b0011;
    aluControl = 2'b01;
    #1;

    if (result !== 4'b0010)
        $fatal(1, "SUB failed: got %b", result);

    //and
    a = 4'b1010;
    b = 4'b1100;
    aluControl = 2'b10;
    #1;

    if (result !== 4'b1000)
        $fatal(1, "AND failed: got %b", result);

    //or
    aluControl = 2'b11;
    #1;

    if (result !== 4'b1110)
        $fatal(1, "OR failed: got %b", result);

    $display("All basic ALU tests passed.");
    $finish;
end

endmodule