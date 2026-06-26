`timescale 1ns/1ps

module asyncResetRegister_tb;

    logic clk;
    logic reset;
    logic [3:0] d;
    logic [3:0] q;

    asyncResetRegister dut (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );

    //clock generator that changes every 5ns
    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        reset = 1'b0;
        d = 4'b1001;

        // test 1: asynchronours reset test
        #2;
        reset = 1'b1;
        #1;
        if (q !== 4'b0000)
            $display(
                "Reset failed: q=%b expected=%b time=%t",
                q, 4'b0000, $time
            );
        
        // test 2: release reset
        reset = 1'b0;

        //new d value and test capture
        d = 4'b1011;


        @(posedge clk);
        #1;
         if (q !== 4'b1011)
            $display(
                "Capture failed: d=%b q=%b expected=%b time=%t",
                d, q, 4'b1011, $time
            );

        // test 3: change d between rising edges and verify q holds.
        d = 4'b0101;
        #2;

        // q should still contain the previously captured value, 1011.
        if (q !== 4'b1011)
            $display(
                "Hold failed: d=%b q=%b expected=%b time=%t",
                d, q, 4'b1011, $time
            );

        // Test 4: verify 0101 is captured at the next rising edge
        @(posedge clk);
        #1;

        if (q !== 4'b0101)
            $display(
            "Second capture failed: d=%b q=%b expected=%b time=%t",
            d, q, 4'b0101, $time
        );

        // test 5: put non-zero value in q to show that q clears immediately (proves the reset is asynchronous)
        d = 4'b1111;

        @(posedge clk);
        #1;
        if (q !== 4'b1111)
            $display(
                "Third capture failed: d=%b q=%b expected=%b time=%t",
                d, q, 4'b1111, $time
            );

        @(negedge clk);
        #1;
        reset = 1'b1;
        #1;
        if (q !== 4'b0000)
            $display(
                "Reset failed: q=%b expected=%b time=%t",
                q, 4'b0000, $time
            );

             $display("Testing complete.");
        $finish;

    end

endmodule

