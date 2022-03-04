`timescale 1ns/1ps

module counter_tb;
    parameter WIDTH     = 16;
    parameter FREQ      = 40_000;
    parameter PERIOD    = 1_000_000_000;

    reg                 clk;    // 40kHz
    reg                 rst_n;
    wire    [WIDTH-1:0] cnt;

    counter c0  (   .clk    (clk),
                    .rst_n   (rst_n),
                    .cnt    (cnt));
    initial begin            
        $dumpfile("counter.vcd");
        $dumpvars(0, counter_tb);
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
