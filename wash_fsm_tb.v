`timescale 1ns/1ps

module wash_fsm_tb;
    parameter WIDTH     = 16;
    parameter FREQ      = 40_000;
    parameter PERIOD    = 10_000_000_000;

    reg     clk;    // 40kHz
    reg     rst_n;
	reg 	start;
	wire 	[1:0]	motor;
	wire 	compl_n;

    wash_fsm c0 (	.clk(clk),
		 		   	.rst_n(rst_n),
					.start(start),
					.motor(motor),
					.compl_n(compl_n));


    initial begin            
        $dumpfile("wash_fsm.vcd");
        $dumpvars(0, wash_fsm_tb);
    end

    always #(500_000_000 / FREQ)
        clk     <= ~clk;

    initial begin
        clk		<= 1'b0;
        rst_n	<= 1'b0;
		start	<= 1'b0;

        //#(1_000_000_000 / FREQ) rst_n	<= 1'b1;
        #(50_000) rst_n	<= 1'b1;
        //#(75_000) rst_n	<= 1'b0;
		//#(50_000)				start	<= 1'b1;
		//#(75_000)				start	<= 1'b0;

        #PERIOD $finish;
    end

endmodule
