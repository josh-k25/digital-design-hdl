`timescale 1ns/1ps

module registerFile_tb;

logic clk;
logic we;
logic [4:0] ra1, ra2;
logic [4:0] wa;
logic [31:0] wd;

logic [31:0] rd1, rd2;

registerFile dut(
    .clk(clk),
    .we(we),
    .ra1(ra1),
    .ra2(ra2),
    .wa(wa),
    .wd(wd),
    .rd1(rd1),
    .rd2(rd2)
);

always #5 clk = ~clk;

initial begin
    we = 1;
    clk = 0;
    ra1 = 5'b00000;
    ra2 = 5'b00000;
    wa = 5'b00000;
    wd = 32'h0000_0000;

    // test write wa wd and ra1
    wa = 5'b00001;
    wd = 32'h8080_8080;
    #1;

    @(posedge clk);
    ra1 = 5'b00001;
    #1;

    if (rd1 !== 32'h8080_8080)
        $fatal(1,"Read data 1 failed: ra1=%d expected=8080_8080", ra1
        );

     // test write wa wd and ra2
    wa = 5'b00010;
    wd = 32'h0808_0808;
    #1;

    @(posedge clk);
    ra2 = 5'b00010;
    #1;

    if (rd2 !== 32'h0808_0808)
        $fatal(1, "Read data 2 failed: ra2=%d expected=0808_0808", ra2
        );

    //test that wa = 5'b00000 ignores the next wd input
    wa = 5'b00000;
    wd = 32'h8888_8888;
    #1;

    @(posedge clk);
    ra1 = 5'b00000;
    #1;

    if (rd1 !== 32'h0000_0000)
        $fatal(1, "Write address to 5'b00000 failed: rd1=%d expected=h0000_0000", rd1
        );

    //test that we = 0 turns off data entry
    we = 0;
    wa = 5'b00010;
    wd = 32'h1111_1111;
    #1;

    @(posedge clk);
    ra2 = 5'b00010;
    #1;

    if (rd2 !== 32'h0808_0808)
        $fatal(1, "Write enable = 0 failed: ra2=%d expected=0808_0808", ra2
        );

    @(posedge clk); 
    if (rd2 !== 32'h0808_0808)
        $fatal(1, "Register hold failed: ra2=%d expected=0808_0808", ra2
        );
    
    $display("All tests passed.");
    $finish;
end

endmodule