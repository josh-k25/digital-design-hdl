module rippleAdder_tb;

localparam int WIDTH = 32;

logic [WIDTH-1:0] a;
logic [WIDTH-1:0] b;
logic             cin;
logic [WIDTH-1:0] sum;
logic             cout;

logic [WIDTH:0] expected;

rippleCarryAdder #(
    .WIDTH(WIDTH)
) dut (
    .a (a),
    .b (b),
    .cin (cin),
    .sum (sum),
    .cout (cout)
);

initial begin
    repeat (10000) begin
        a   = $urandom;
        b   = $urandom;
        cin = $urandom_range(0, 1);

        #1;

        expected = {1'b0, a} + {1'b0, b} + cin;

        if ({cout, sum} !== expected) begin
            $fatal( 1, "Mismatch: a=%h b=%h cin=%b, got=%h expected=%h", a, b, cin, {cout, sum}, expected
            );
        end
    end

    $display("All random tests passed.");
    $finish;
end

endmodule