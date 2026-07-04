`timescale 1ns/1ps

module instructionMemory_tb;

localparam int test_DEPTH = 8;
localparam int test_WIDTH = 32;
logic [$clog2(test_DEPTH)-1:0] address;

logic [test_WIDTH-1:0] rd;

instructionMemory #(
    .DEPTH(test_DEPTH),
    .WIDTH(test_WIDTH),
    .fileName("program.hex")
) dut (
    .address(address),
    .rd(rd)
);

initial begin
    //check first entry 
    address = 3'b000;
    #1;

    if (rd !== 32'h00000000)
        $fatal(1,"First entry read failed: rd=%h expected=00000000", rd
        );
    
    //check last entry
    address = 3'b111;
    #1;

    if(rd !== 32'hCAFEBABE)
        $fatal(1, "Last entry read failed: rd=%h expected=CAFEBABE", rd
        );

    //check middle entry
    address = 3'b100;
    #1;

    if(rd !== 32'hA5A5A5A5)
        $fatal(1,"Middle entry read failed: rd=%h expected=A5A5A5A5", rd
        );

    $display("All tests passed");
    $finish;
end
endmodule


