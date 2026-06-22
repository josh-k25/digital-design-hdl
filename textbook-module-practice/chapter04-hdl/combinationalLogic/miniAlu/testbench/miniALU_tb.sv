`timescale 1ns/1ps 

module miniALU_tb;

    logic [3:0] a;
    logic [3:0] b;
    logic [1:0] operation;
    logic [3:0] result;

    miniAlu dut (
        .a(a),
        .b(b),
        .operation(operation),
        .result(result)
    );

    initial begin

        // test 1: AND
        a = 4'b0011;   // 3
        b = 4'b0101;   // 5
        operation = 2'b00;
        #10;

        if (result !== 4'b0001)
            $display(
                "AND failed: a=%b b=%b result=%b expected=%b", a, b, result, 4'b0001
            );

        // test 2: OR
        a = 4'b0011;
        b = 4'b0101;
        operation = 2'b01;
        #10;

        if (result !== 4'b0111)
            $display (
                "OR failed: a=%b b=%b result=%b expected=%b", a, b, result, 4'b0111
            );

        //test 3: XOR
        a = 4'b1011;
        b = 4'b0101;
        operation = 2'b10;
        #10;

        if (result !== 4'b1110)
            $display(
                "XOR failed: a=%b b=%b result=%b expected=%b", a, b, result, 4'b1110
            );

        //test 4: ADD
        a = 4'b0011;   // 3
        b = 4'b0101;   // 5
        operation = 2'b11;
        #10;

        if (result !== 4'b1000)
            $display(
                "ADD failed:  a=%b b=%b result=%b expected=%b", a, b, result, 4'b1000
            );
        
        $display("Testing complete.");
        $finish;
    end

endmodule    



