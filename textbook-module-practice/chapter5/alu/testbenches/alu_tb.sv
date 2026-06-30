module aluNoFlags_tb;

logic [3:0] a;
logic [3:0] b;
logic [1:0] aluControl;
logic [3:0] result;

logic N;
logic Z;
logic C;
logic V;


alu dut (
    .a (a),
    .b (b),
    .aluControl (aluControl),
    .result (result),
    .N (N),
    .Z (Z),
    .C (C),
    .V (V)
);

initial begin
    //add: 2 + 3 = 5
    a = 4'b0010;
    b = 4'b0011;
    aluControl = 2'b00;
    #1;

    if (result !== 4'b0101)
        $fatal(1, 
            "ADD failed: got %b", result
    );

    //subtract: 5 - 3 = 2
    a = 4'b0101;
    b = 4'b0011;
    aluControl = 2'b01;
    #1;

    if (result !== 4'b0010)
        $fatal(1, 
            "SUB failed: got %b", result
    );

    //and
    a = 4'b1010;
    b = 4'b1100;
    aluControl = 2'b10;
    #1;

    if (result !== 4'b1000)
        $fatal(1, 
            "AND failed: got %b", result
    );

    //or
    aluControl = 2'b11;
    #1;

    if (result !== 4'b1110)
        $fatal(1, 
            "OR failed: got %b", result
    );


    //zero flag test (5 - 5 = 0)
    a = 4'b0101;
    b = 4'b0101;
    aluControl = 2'b01;
    #1;
    
    if (result !== 4'b0000 || Z !== 1'b1)
        $fatal(1, 
            "Z failed: got Z=%b and result=%b", Z, result
    );

    //negative flag test (3 - 5 = -2)
    a = 4'b0011;
    b = 4'b0101;
    aluControl = 2'b01;
    #1;

    if (result !== 4'b1110 || N !== 1'b1)
        $fatal(1,
            "N failed: got N=%b and result=%b", N, result
    );

    //carry flag test (15 + 1 = 0 w carry-out)
    a = 4'b1111;
    b = 4'b0001;
    aluControl = 2'b00;
    #1;

    if (result !== 4'b0000 || C !== 1'b1)
        $fatal(1,
            "C failed: got C=%b and result=%b", C, result
    );

    //carry should remain off: 2 + 3 = 5
    a = 4'b0010;
    b = 4'b0011;
    aluControl = 2'b00;
    #1;

    if (result !== 4'b0101 || C !== 1'b0)
        $fatal(1,
            "C incorrectly asserted: got C=%b and result=%b", C, result
        );

    //overflow test 1: pos + pos -> neg looking result
    a= 4'b0111;
    b = 4'b0001;
    aluControl = 2'b00;
    #1;

    if (result !== 4'b1000 || V !== 1'b1)
        $fatal(1,
            "ADD overflow failed: 7 + 1, result=%b V=%b", result, V
    );

        //overflow test 2: neg + neg -> pos looking result
    a = 4'b1100;
    b = 4'b1011;
    aluControl = 2'b00;
    #1;

    if (result !== 4'b0111 || V !== 1'b1)
        $fatal(1,
            "ADD overflow failed: -4 + -5, result=%b V=%b", result, V
    );


    //overflow test 3: pos - neg -> neg looking result
    a = 4'b0111;
    b = 4'b1111;
    aluControl = 2'b01;
    #1;

    if (result !== 4'b1000 || V !== 1'b1)
        $fatal(1,
            "SUB overflow failed: 7 - (-1), result=%b V=%b", result, V
    );


    //overflow test 4: neg - pos -> pos looking result
    a = 4'b1000;
    b = 4'b0001;
    aluControl = 2'b01;
    #1;

    if (result !== 4'b0111 || V !== 1'b1)
        $fatal(1,
            "SUB overflow failed: -8 - 1, result=%b V=%b", result, V
    );
    
    //overflow test 5: pos - pos -> pos result (V should be off)
    a = 4'b0100;
    b = 4'b0001;
    aluControl = 2'b01;
    #1;

    if (result !== 4'b0011 || V !== 1'b0)
        $fatal(1,
            "SUB incorrectly asserted overflow: 4 - 1, result=%b V=%b", result, V
    );

    //overflow test 6: pos + pos -> pos result 
    a = 4'b0100;
    b = 4'b0001;
    aluControl = 2'b00;
    #1;

    if (result !== 4'b0101 || V !== 1'b0)
        $fatal(1,
            "ADD incorrectly asserted overflow: 4 + 1, result=%b V=%b", result, V
    );

    $display("All ALU tests with flags passed.");
    $finish;
end

endmodule