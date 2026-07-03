module shifter_tb;

input logic [31:0] num;
input logic [1:0] shiftType;
input logic [4:0] shiftAmount;  

output logic [31:0] result;

shifter dut(
    .num(num),
    .shiftType(shiftType),
    .shiftAmount(shiftAmount),
    .result(result)
);

intial begin
    //logical left by 0 
    num = 32'h80000000;
    shiftType = 2'b00;
    shiftAmount = 4'b00000;
    #1;

    if(num !== 32'h80000000)
        $fatal(1,
        "Logical left by 0 failed, num=%d expected=80000000", num
        );
    
    