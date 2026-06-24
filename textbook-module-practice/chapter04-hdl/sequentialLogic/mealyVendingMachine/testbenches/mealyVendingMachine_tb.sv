`timescale 1ns/1ps

module mealyVendingMachine_tb;

    logic clk;
    logic reset;
    logic nickel;
    logic dime;
    logic dispense;

    integer errors;

    mealyVendingMachine dut (
        .clk(clk),
        .reset(reset),
        .nickel(nickel),
        .dime(dime),
        .dispense(dispense)
    );

    // 10 ns clock period
    always #5 clk = ~clk;

    initial begin

        clk      = 1'b0;
        reset    = 1'b0;
        nickel   = 1'b0;
        dime     = 1'b0;
        errors   = 0;

        //test 1: asynchronous reset away from rising edge

        #2;
        reset = 1'b1;

        #1;

        if (dispense !== 1'b0) begin
            $display(
                "Reset failed: dispense=%b expected=%b time=%t", dispense, 1'b0, $time
            );

            errors = errors + 1;
        end

        reset = 1'b0;

        //test 2: insert a nickel from 0 cents to reach 5 cents

        @(negedge clk);
        nickel = 1'b1;
        dime   = 1'b0;

        #1;

        if (dispense !== 1'b0) begin
            $display(
                "Dispense failed before posedge (showed high with 5 cents): dispense=%b expected=%b time=%t", dispense, 1'b0, $time
            );

            errors = errors + 1;
        end

        @(posedge clk);
        #1;

        nickel = 1'b0;
        #1;

        if (dispense !== 1'b0) begin
            $display(
                "Dispense failed after posedge (showed high with 5 cents): dispense=%b expected=%b time=%t", dispense, 1'b0, $time
            );

            errors = errors + 1;
        end

        //test 3: prove Mealy timing with dime while at 5 cents

        @(negedge clk);
        dime = 1'b1;

        #1;

        // While still in the 5-cent state, the dime should make dispense high before the next rising edge.
        if (dispense !== 1'b1) begin
            $display(
                "Mealy timing failed: dispense=%b expected=%b time=%t", dispense, 1'b1, $time
            );

            errors = errors + 1;
        end

        @(posedge clk);
        #1;

        // The rising edge moves the FSM back to S0. With the FSM now in S0, dispense should return low.
        if (dispense !== 1'b0) begin
            $display(
                "Return to zero-credit state failed: dispense=%b expected=%b time=%t", dispense, 1'b0, $time
            );

            errors = errors + 1;
        end

        dime = 1'b0;

        //test 4: insert a dime from 0 cents to reach 10 cents

        @(negedge clk);
        dime = 1'b1;

        #1;

        if (dispense !== 1'b0) begin
            $display(
                "Dime from 0 cents dispensed too early: dispense=%b expected=%b time=%t", dispense, 1'b0, $time
            );

            errors = errors + 1;
        end

        @(posedge clk);
        #1;

        dime = 1'b0;
        #1;

        if (dispense !== 1'b0) begin
            $display(
                "Dime from 0 cents incorrectly dispensed after being stored: dispense=%b expected=%b time=%t", dispense, 1'b0, $time
            );

            errors = errors + 1;
        end

        //test 5: add nickel while at 10 cents

        @(negedge clk);
        nickel = 1'b1;

        #1;

        if (dispense !== 1'b1) begin
            $display(
                "Dispense failed: dispense=%b expected=%b time=%t", dispense, 1'b1, $time
            );

            errors = errors + 1;
        end

        @(posedge clk);
        #1;

        if (dispense !== 1'b0) begin
            $display(
                "Dispense reset failed: dispense=%b expected=%b time=%t", dispense, 1'b0, $time
            );

            errors = errors + 1;
        end

        nickel = 1'b0;

        //test 6: insert two nickels to reach 10 cents

        @(negedge clk);
        nickel = 1'b1;

        #1;

        if (dispense !== 1'b0) begin
            $display(
                "Nickel from 0 cents dispensed too early: dispense=%b expected=%b time=%t", dispense, 1'b0, $time
            );

            errors = errors + 1;
        end

        @(posedge clk);
        #1;

        nickel = 1'b0;
        #1;

        if (dispense !== 1'b0) begin
            $display(
                "Nickel from 0 cents dispensed after being stored: dispense=%b expected=%b time=%t", dispense, 1'b0, $time
            );

            errors = errors + 1;
        end

        @(negedge clk);
        nickel = 1'b1;

        #1;

        if (dispense !== 1'b0) begin
            $display(
                "Nickel from 5 cents dispensed too early: dispense=%b expected=%b time=%t", dispense, 1'b0, $time
            );

            errors = errors + 1;
        end

        @(posedge clk);
        #1;

        nickel = 1'b0;
        #1;

        if (dispense !== 1'b0) begin
            $display(
                "Second nickel incorrectly dispensed after reaching 10 cents: dispense=%b expected=%b time=%t", dispense, 1'b0, $time
            );

            errors = errors + 1;
        end

        //test 7: add another nickel while at 10 cents

        @(negedge clk);
        nickel = 1'b1;

        #1;

        if (dispense !== 1'b1) begin
            $display(
                "Nickel from 10 cents did not dispense: dispense=%b expected=%b time=%t", dispense, 1'b1, $time
            );

            errors = errors + 1;
        end

        @(posedge clk);
        #1;

        if (dispense !== 1'b0) begin
            $display(
                "Dispense reset from 15 cents failed: dispense=%b expected=%b time=%t", dispense, 1'b0, $time
            );

            errors = errors + 1;
        end

        nickel = 1'b0;

        //test 8: hold state when no coin is inserted

        @(negedge clk);
        nickel = 1'b1;

        @(posedge clk);
        #1;

        nickel = 1'b0;
        #1;

        @(posedge clk);
        #1;

        if (dispense !== 1'b0) begin
            $display(
                "No-coin hold produced dispense: dispense=%b expected=%b time=%t", dispense, 1'b0, $time
            );

            errors = errors + 1;
        end

        @(negedge clk);
        dime = 1'b1;

        #1;

        if (dispense !== 1'b1) begin
            $display(
                "Hold state failed: dispense=%b expected=%b time=%t", dispense, 1'b1, $time
            );

            errors = errors + 1;
        end

        dime = 1'b0;
        #1;

        if (dispense !== 1'b0) begin
            $display(
                "Dispense did not return low after dime was removed: dispense=%b expected=%b time=%t", dispense, 1'b0, $time
            );

            errors = errors + 1;
        end

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("%0d TESTS FAILED", errors);

        $finish;
    end

endmodule