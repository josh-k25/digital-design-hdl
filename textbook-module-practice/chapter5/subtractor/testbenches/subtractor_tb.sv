module subtractor_tb;

localparam int WIDTH = 4;

logic [WIDTH - 1:0] a;
logic [WIDTH - 1:0] b;
logic [WIDTH - 1:0] difference;

logic [WIDTH - 1:0] expected;

subtractor #(
    .WIDTH(WIDTH)
) dut (
    .a(a),
    .b(b),
    .difference(difference)
);

initial begin
    //test 1: 5 - 3 = 2
    a = 4'b0101;
    b = 4'b0011;

    #1;

    expected = 5 - 3;

    if (difference !== expected) begin
        $fatal(
            1, "5 - 3 failed: a=%b b=%b, difference=%b expected=%b"
        );
    end

    //test 2: 3 - 5 = -2, represented as 1110
    a = 4'b0011;
    b = 4'b0101;

    #1;

    expected = 3 - 5;

    if (difference !== expected) begin
        $fatal(
            1, "3 - 5 failed: a=%b b=%b, difference=%b expected=%b"
        );
    end

    //test 3: 0 - 0 = 0
    a = 4'b0000;
    b = 4'b0000;

    #1;

    expected = 0 - 0;

    if (difference !== expected) begin
        $fatal(
            1, "0 - 0 failed: a=%b b=%b, difference=%b expected=%b"
        );
    end
    
    $display("All subtractor tests passed.");
    $finish;
end

endmodule