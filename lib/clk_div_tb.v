`timescale 1ns/1ps

module clk_div_tb;
    parameter WIDTH     = 16;
    parameter FREQ      = 40_000;
    parameter PERIOD    = 4_000_000_000;

    reg     clk;    // 40kHz
    reg     rst_n;
    wire    [WIDTH-1:0] cnt;
    wire    clk_out;
    wire    cnt_rst_n;
    wire    counter_rst_n;

    assign  counter_rst_n    = rst_n & cnt_rst_n;

    counter c0  (   .clk(clk),
                    .rst_n(counter_rst_n),
                    .cnt(cnt));

    clk_div cd0 (   .clk    (clk),
                    .rst_n   (rst_n),
                    .cnt    (cnt),
                    .clk_out(clk_out),
                    .cnt_rst_n(cnt_rst_n));

    initial begin            
        $dumpfile("clk_div.vcd");
        $dumpvars(0, clk_div_tb);
    end

    always #(500_000_000 / FREQ)
    // always #1
        clk     <= ~clk;

    initial begin
        clk         <= 1'b0;
        rst_n        <= 1'b0;

        #(1_000_000_000 / FREQ)  rst_n    <= 1'b1;

        #PERIOD $finish;
    end

endmodule
