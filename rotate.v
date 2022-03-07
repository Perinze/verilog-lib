module wash_fsm # (
    parameter CNTW = 6,      // count width
    parameter SW = 3,       // state width
    parameter MW = 2,       // motor width
    parameter CW = 32,
    parameter CCW = 32,
    parameter PAUSE = 16,
    parameter S0 = 0,
    parameter S1 = 1,
    parameter S2 = 2,
    parameter S3 = 3,
    parameter S4 = 4,
    parameter M0 = 0,
    parameter M1 = 1,
    parameter M2 = 2
) (
    input clk,		// 1Hz
    input rst_n,
    // 0 for stop, 1 for clockwise, 2 for counterclockwise, 3 undefined
    output [1:0] motor,
    // 0 for stopping, 1 for working
    // negedge indicate completion
    output compl_n
);

wire [CNTW-1:0] cnt;
reg [SW-1:0] state;
wire [SW-1:0] next;
wire clear;
reg clear_reg;

counter #(.WIDTH(CNTW))    c0	(	.clk(clk),
			                        .rst_n(clear),
			                        .cnt(cnt));

assign motor = {SW{rst_n}} &   (state == S1 ? M1 :
                                state == S2 ? M0 :
                                state == S3 ? M2 :
                                state == S4 ? M0 : M0);

assign clear = rst_n & over;

assign next =  (state == S1 && cnt == CW    ? S2 :
                state == S2 && cnt == PAUSE ? S3 :
                state == S3 && cnt == CCW   ? S4 :
                state == S4 && cnt == PAUSE ? S0 : state);

assign over =  (state == S1 && cnt == CW    ? 0 :
                state == S2 && cnt == PAUSE ? 0 :
                state == S3 && cnt == CCW   ? 0 :
                state == S4 && cnt == PAUSE ? 0 : 1);

assign compl_n = (state != S0);

always@(posedge clk) begin
    if (~rst_n)
        state <= S1;
    else
        state <= next;
end

endmodule
