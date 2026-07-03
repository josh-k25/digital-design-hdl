module shifter_tb;

logic [31:0] num;
logic [1:0] shiftType;
logic [4:0] shiftAmount;  

logic [31:0] result;

shifter dut(
    .num(num),
    .shiftType(shiftType),
    .shiftAmount(shiftAmount),
    .result(result)
);

initial begin
    //logical left by 0 
    num = 32'h80000000;
    shiftType = 2'b00;
    shiftAmount = 5'b00000;
    #1;

    if(result !== 32'h8000_0000)
        $fatal(1,
        "Logical left by 0 failed, num=%d expected=8000_0000", num
        );

    //logical left by 1
    num = 32'h80000000;
    shiftType = 2'b00;
    shiftAmount = 5'b00001;
    #1;

    if(result !== 32'h0000_0000)
        $fatal(1,
        "Logical left by 1 failed, num=%d expected=0000_0000", num
        );

    //logical left by 31
    num = 32'hffff_ffff;
    shiftType = 2'b00;
    shiftAmount = 5'b11111;
    #1;

    if(result !== 32'h8000_0000)
        $fatal(1,
        "Logical left by 32 failed, num=%d expected=8000_0000", num
        );

    //logical right by 0 
    num = 32'h80000000;
    shiftType = 2'b01;
    shiftAmount = 5'b00000;
    #1;

    if(result !== 32'h8000_0000)
        $fatal(1,
        "Logical right by 0 failed, num=%d expected=8000_0000", num
        );

    //logical right by 1
    num = 32'h80000000;
    shiftType = 2'b01;
    shiftAmount = 5'b00001;
    #1;

    if(result !== 32'h4000_0000)
        $fatal(1,
        "Logical right by 1 failed, num=%d expected=4000_0000", num
        );

    //logical left by 31
    num = 32'hffff_ffff;
    shiftType = 2'b01;
    shiftAmount = 5'b11111;
    #1;

    if(result !== 32'h0000_0001)
        $fatal(1,
        "Logical right by 31 failed, num=%d expected=0000_0001", num
        );

    //arithmetic right by 1 with msb 1
    num = 32'h8000_0000;
    shiftType = 2'b10;
    shiftAmount = 5'b00001;
    #1;

    if(result !== 32'hc000_0000)
        $fatal(1,
        "Arithmetic right by 1 (MSB = 1) failed, num=%d expected=c000_0000", num
        );
    
    //arithmetic right by 1 with msb 0
    num = 32'h4000_0000;
    shiftType = 2'b10;
    shiftAmount = 5'b00001;
    #1;

    if(result !== 32'h2000_0000)
        $fatal(1,
        "Arithmetic right by 1 (MSB = 0) failed, num=%d expected=2000_0000", num
        );
    
    $display("All ALU tests with flags passed.");
    $finish;
    end
endmodule