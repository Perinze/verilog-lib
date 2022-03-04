`timescale 1ns/1ps

module clk_1hz_tb;
    parameter WIDTH     = 16;
    parameter FREQ      = 40_000;
    parameter PERIOD    = 4_000_000_000;

    reg     clk;    // 40kHz
    reg     rst_n;
    wire    clk_out;

    clk_1hz c0 (	.clk(clk),
		    	.rst_n(rst_n),
			.clk_out(clk_out));

    initial begin            
        $dumpfile("clk_1hz.vcd");
        $dumpvars(0, clk_1hz_tb);
    end

    always #(500_000_000 / FREQ)
        clk     <= ~clk;

    initial begin
        clk         <= 1'b0;
        rst_n        <= 1'b0;

        #(1_000_000_000 / FREQ)  rst_n    <= 1'b1;

        #PERIOD $finish;
    end

endmodule
