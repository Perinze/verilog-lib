wash_fsm: wash_fsm.v wash_fsm_tb.v lib/counter.v lib/clk_div.v lib/clk_1hz
	verilog -o wash_fsm wash_fsm.v wash_fsm_tb.v lib/counter.v lib/clk_div.v lib/clk_1hz
