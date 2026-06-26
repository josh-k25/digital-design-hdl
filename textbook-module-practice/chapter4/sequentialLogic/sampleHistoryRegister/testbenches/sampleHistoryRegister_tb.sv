`timescale 1ns/1ps 

module sampleHistoryRegister_tb;

    logic clk;
    logic reset;
    logic clear;
    logic capture;
    logic [3:0] d;
    logic [3:0] current;
    logic [3:0] previous;

    integer errors;

    sampleHistoryRegister dut(
        .clk(clk),
        .reset(reset),
        .clear(clear),
        .capture(capture),
        .d(d),
        .current(current),
        .previous(previous)
    );

    // 10 ns clock period
    always #5 clk = ~clk;

    initial begin

    clk = 1'b0;
    reset = 1'b0;
    clear = 1'b0;
    capture = 1'b0;
    d = 4'b0110;
    errors  = 0;

    // test 1: asynchronous reset test away from rising edge

    @(negedge clk);
    #1;

    reset = 1'b1;
    #1;

    if ((current !== 4'b0000) || (previous !== 4'b0000)) begin
        $display(
                "Reset failed: current=%b previous=%b time=%t",
                current, previous, $time
            );

            errors = errors + 1;
        end
    
    // Release reset
    reset = 1'b0;

    // test 2: capture test 
    d = 4'b1101;
    capture = 1'b1;

    @(posedge clk);
    #1;

    if ((current !== 4'b1101) || (previous !== 4'b0000)) begin 
        $display(
            "First capture failed: current=%b previous=%b expected_current=%b expected_previous=%b time=%t", current, previous, 4'b1101, 4'b0000, $time
        );
       
    errors = errors + 1;
    end

    //test 3: ensure that current and previous hold when capure is disabled and d is changed
    capture = 1'b0;
    d = 4'b1111;

    @(posedge clk);
    #1;

    if ((current !== 4'b1101) || (previous !== 4'b0000)) begin
        $display("Hold failed: current=%b previous=%b expected_current=%b expected_previous=%b time=%t", current, previous, 4'b1101, 4'b0000, $time);

    errors = errors + 1;
    end

    //test 4: try second capture and ensure previous takes the old current
    capture = 1'b1;
    d = 4'b0101;

    @(posedge clk);
    #1;

    if ((current !== 4'b0101) || (previous !== 4'b1101)) begin
        $display("Second captrue failed: current=%b previous=%b expected_current=%b expected_previous=%b time=%t", current, previous, 4'b0101, 4'b1101, $time);

    errors = errors + 1;
    end

    //test 5: synchronous clear test 

    @(negedge clk);
    #1;

    clear = 1'b1;

    #1;

    if ((current !== 4'b0101) || (previous !== 4'b1101)) begin
        $display("Synchronous clear failed (cleared too early): current=%b previous=%b expected_current=%b expected_previous=%b time=%t", current, previous, 4'b0101, 4'b1101, $time);
        
    errors = errors + 1;
    end

    @(posedge clk);
    #1;

    if ((current !== 4'b0000) || (previous !== 4'b0000)) begin
        $display("Synchronous clear failed (did not clear): current=%b previous=%b expected_current=%b expected_previous=%b time=%t", current, previous, 4'b0000, 4'b0000, $time);

    errors = errors + 1;
    end

    clear = 1'b0;

    //test 6: clear priority over capture

    clear   = 1'b1;
    capture = 1'b1;
    d       = 4'b0100;

    @(posedge clk);
    #1;

    if ((current !== 4'b0000) || (previous !== 4'b0000)) begin
        $display("Clear priority over capture failed: current=%b previous=%b expected_current=%b expected_previous=%b time=%t", current, previous, 4'b0000, 4'b0000, $time);

    errors = errors + 1;
    end

     if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("%0d TESTS FAILED", errors);

        $finish;
    end

endmodule