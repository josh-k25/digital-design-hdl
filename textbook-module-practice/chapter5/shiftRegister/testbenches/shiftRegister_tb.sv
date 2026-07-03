`timescale 1ns/1ps

module shiftRegister_tb;

logic clk;
logic reset;
logic in;

logic [3:0] q;

shiftRegister dut(
    .clk(clk),
    .reset(reset),
    .in(in),
    .q(q)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;
    in = 0;
    #1;

    reset = 0;

    //test 1 --> 0 --> 1 --> 1 --> 0 pattern and then reset 
    in = 1;
    #1;

    @(posedge clk);
    #1;
    if(q !== 4'b1000)
        $fatal(1, 
            "Shift #1 failed: q=%b expected=1000", q
    );

    in = 0;
    #1;

    @(posedge clk);
    #1;
    if(q !== 4'b0100)
        $fatal(1, 
            "Shift #2 failed: q=%b expected=0100", q
    );

    in = 1;
    #1;

    @(posedge clk);
    #1;
    if(q !== 4'b1010)
        $fatal(1, 
            "Shift #3 failed: q=%b expected=1010", q
    );

    in = 1;
    #1;

    @(posedge clk);
    #1;
    if(q !== 4'b1101)
        $fatal(1, 
            "Shift #4 failed: q=%b expected=1101", q
    );

    in = 0;
    #1;

    @(posedge clk);
    #1;
    if(q !== 4'b0110)
        $fatal(1,
            "Shift #5 failed: q=%b expected=0110", q
    );

    reset = 1;
    #1;

    if(q !== 4'b0000)
        $fatal(1,
            "Reset failed: q=%b expected=0000", q
    );

    $display("All tests passed.");
    $finish;
end

endmodule
