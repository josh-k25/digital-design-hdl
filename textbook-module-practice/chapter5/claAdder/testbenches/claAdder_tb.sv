module claAdder_tb;

logic [3:0] a;
logic [3:0] b;
logic cin;

logic [3:0] sum;
logic cout;

logic [4:0] expected;

claAdder dut(
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .cout(cout)
);

initial begin
    for (int ai = 0; ai < 16; ai++) begin
        for (int bi = 0; bi < 16; bi++) begin
            for (int ci = 0; ci < 2; ci++) begin
                a = ai;
                b = bi;
                cin = ci;

                #1;

                expected = {1'b0, a} + {1'b0, b} + cin;

                if ({cout, sum} !== expected) begin
                    $fatal( 1, "Mismatch: a=%b b=%b cin=%b got=%b expected=%b", a, b, cin, {cout, sum}, expected
                    );
                end
            end
        end
    end

    $display("All CLA tests passed.");
    $finish;
end

endmodule