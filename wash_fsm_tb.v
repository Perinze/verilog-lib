`timescale 1s/1us

module wash_fsm_tb;
    parameter WIDTH     = 16;
    parameter FREQ      = 1;
    parameter PERIOD    = 30;

    reg     clk;    // 40kHz
    reg     rst_n;
	wire 	[1:0]	motor;
	wire 	compl_n;

    wash_fsm c0 (	.clk(clk),
		 		   	.rst_n(rst_n),
					.motor(motor),
					.compl_n(compl_n));


    initial begin            
        $dumpfile("wash_fsm.vcd");
        $dumpvars(0, wash_fsm_tb);
    end

    always #(0.5 / FREQ)
        clk     <= ~clk;

    initial begin
        clk		<= 1'b1;

        rst_n	<= 1'b0;
        #(2) rst_n	<= 1'b1;

        #(15) rst_n <= 1'b0;
        #(16) rst_n <= 1'b1;

        #PERIOD $finish;
    end

endmodule
