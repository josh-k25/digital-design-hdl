`timescale 1ns/1ps

module mooreTurnstile_tb;

    logic clk;
    logic reset;
    logic coin;
    logic push;
    logic unlocked;
    logic alarm;

    integer errors;

    mooreTurnstile dut (
        .clk(clk),
        .reset(reset),
        .coin(coin),
        .push(push),
        .unlocked(unlocked),
        .alarm(alarm)
    );

    // 10 ns clock period
    always #5 clk = ~clk;

    initial begin

        clk    = 1'b0;
        reset  = 1'b0;
        coin   = 1'b0;
        push   = 1'b0;
        errors = 0;

        //test 1: asynchronous test away from rising edge (machine should lock instantly)
        #2;
        reset = 1'b1;

        #1;

        if ((unlocked !== 1'b0) || (alarm !== 1'b0)) begin

            $display(
                "Reset failed: unlocked=%b alarm=%b time=%t",
                unlocked, alarm, $time
            );

            errors = errors + 1;
        end

        reset = 1'b0;

        //test 2: insert a coin while locked to unlock after rising edge

        @(negedge clk);
        coin = 1'b1;
        push = 1'b0;

        @(posedge clk);
        #1;

        if ((unlocked !== 1'b1) || (alarm !== 1'b0)) begin
            $display(
                "Unlock failed: unlocked=%b alarm=%b expected_unlocked=%b expected_alarm=%b time=%t",
                unlocked, alarm, 1'b1, 1'b0, $time
            );

            errors = errors + 1;
        end

        coin = 1'b0;

        //test 3: prove Moore timing (push only affects nextstate not output)
        @(negedge clk);
        push = 1'b1;

        #1;

        if ((unlocked !== 1'b1) || (alarm !== 1'b0)) begin
            $display(
                "Moore timing failed (push changed output): unlocked=%b alarm=%b expected_unlocked=%b expected_alarm=%b time=%t",
                unlocked, alarm, 1'b1, 1'b0, $time
            );

            errors = errors + 1;
        end

        @(posedge clk);
        #1;

        if ((unlocked !== 1'b0) || (alarm !== 1'b0)) begin
            $display(
                "Moore timing failed (push did not change next state): unlocked=%b alarm=%b expected_unlocked=%b expected_alarm=%b time=%t",
                unlocked, alarm, 1'b0, 1'b0, $time
            );

            errors = errors + 1;
        end

        push = 1'b0;

        //test 4: push while locked 

        @(negedge clk);
        push = 1'b1;

        @(posedge clk);
        #1;

        if ((unlocked !== 1'b0) || (alarm !== 1'b1)) begin
            $display(
                "Alarm failed: unlocked=%b alarm=%b expected_unlocked=%b expected_alarm=%b time=%t",
                unlocked, alarm, 1'b0, 1'b1, $time
            );
        
            errors = errors + 1;
        end

        push = 1'b0;

        //test 5: alarm returns to locked after 1 cycle
        @(posedge clk);
        #1;

        if ((unlocked !== 1'b0) || (alarm !== 1'b0)) begin
            $display(
                "Autolocking failed: unlocked=%b alarm=%b expected_unlocked=%b expected_alarm=%b time=%t",
                unlocked, alarm, 1'b0, 1'b0, $time
            );

            errors = errors + 1;
        end
            
        //test 6: add coin while already unlocked

        // First coin: move from locked to unlocked
        coin = 1'b1;
        push = 1'b0;

        @(posedge clk);
        #1;

        if ((unlocked !== 1'b1) || (alarm !== 1'b0)) begin
            $display(
                "Initial unlock failed: unlocked=%b alarm=%b expected_unlocked=%b expected_alarm=%b time=%t",
                unlocked, alarm, 1'b1, 1'b0, $time
            );

            errors = errors + 1;
        end

        @(negedge clk);
        coin = 1'b0;

        #1;
        coin = 1'b1;

        @(posedge clk);
        #1;

        if ((unlocked !== 1'b1) || (alarm !== 1'b0)) begin
            $display(
                "Coin while unlocked failed: unlocked=%b alarm=%b expected_unlocked=%b expected_alarm=%b time=%t",
                unlocked, alarm, 1'b1, 1'b0, $time
            );

            errors = errors + 1;
        end

        coin = 1'b0;

        //test 7: hold state (test low for both inputs)
        coin = 1'b0;
        push = 1'b0;

        @(posedge clk);
        #1;

        if ((unlocked !== 1'b1) || (alarm !== 1'b0)) begin
            $display(
                "Hold state failed: unlocked=%b alarm=%b expected_unlocked=%b expected_alarm=%b time=%t",
                unlocked, alarm, 1'b1, 1'b0, $time
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