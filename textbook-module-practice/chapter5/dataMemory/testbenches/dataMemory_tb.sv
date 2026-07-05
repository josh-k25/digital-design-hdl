`timescale 1ns/1ps

module dataMemory_tb;

localparam int DEPTH = 8;

logic clk;
logic we;
logic [$clog2(DEPTH)-1:0] address;
logic [31:0] wd;

logic [31:0] rd;

dataMemory #(
    .DEPTH(DEPTH)
) dut (
    .clk(clk),
    .we(we),
    .address(address),
    .wd(wd),
    .rd(rd)
);

always #5 clk = ~clk;

initial begin
    
    //test write data
    clk = 0;
    we = 1;
    wd = 32'h8888_8888;
    address = 3'b000;

    @(posedge clk);
    #1;
    if(rd !== 32'h8888_8888)
        $fatal(1, "Initial read and write failed: rd=%h expected=8888_8888", rd
        );

    //change wd and verify that old value is held before next clock edge and new value only changes after clock edge
    wd = 32'h7777_7777;
    #1;

    if(rd !== 32'h8888_8888)
        $fatal(1, "Synchronous hold failed: rd=%h expected=8888_8888", rd
        );

    @(posedge clk);
    #1;
    if(rd !== 32'h7777_7777)
        $fatal(1, "Synchronous write failed: rd=%h expected=7777_7777", rd
        );

    //test that we=0 stops writing 
    we = 0;
    wd = 32'h2222_2222;

    @(posedge clk);
    #1;
    if(rd !== 32'h7777_7777)
        $fatal(1, "Write disable failed: rd=%h expected=7777_7777", rd
        );

    //test address independence
    we = 1;
    wd = 32'haaaa_aaaa;

    @(posedge clk);
    #1;
    address = 3'b001;
    wd = 32'hbbbb_bbbb;

    @(posedge clk);
    #1;
    if (rd !== 32'hbbbb_bbbb)
        $fatal(1, "B write failed: rd=%h expected=bbbb_bbbb", rd
        );
    
    address = 3'b000;
    #1;

    if (rd !== 32'haaaa_aaaa)
        $fatal(1, "A write failed: rd=%h expected=aaaa_aaaa", rd
        );
    
    //test last address write
    address = 3'b111;
    wd = 32'hcccc_cccc;

    @(posedge clk);
    #1;
    if (rd !== 32'hcccc_cccc)
        $fatal(1, "Last address write failed: rd=%h expected=cccc_cccc", rd
        );

    $display("All tests passed.");
    $finish;
end
endmodule
    