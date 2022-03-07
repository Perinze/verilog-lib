module wash_fsm # (
    parameter MOTOR_W = 2,
    parameter CNT_W = 4,
    parameter ROT_CNT_W = 6,
    parameter STATE_W = 4,
    // step 1
    parameter WATER_IN_1st = 3,   // S1
    parameter CW_ROT_1st = 4,     // S2
    parameter CCW_ROT_1st = 4,
    parameter PAUSE_1st = 2,
    parameter REP_1st = 5,
    parameter WATER_OUT_1st = 3,  // S3
    // step 2
    parameter WATER_IN_2nd = 3,
    parameter CW_ROT_2nd = 4,
    parameter CCW_ROT_2nd = 4,
    parameter PAUSE_2nd = 2,
    parameter ROT_REP_2nd = 5,
    parameter REP_2nd = 3,
    // step 3
    parameter CW_ROT = 6
) (
    input                   clk,
    input                   rst_n,
    input                   start,
    output  [MOTOR_W-1:0]   motor,
    output                  water_in,
    output                  water_out
);

localparam STATE_IDLE = 0;
localparam STATE_1ST = 1;
localparam STATE_WAIT2ND = 2;
localparam STATE_2ND = 3;

assign state_idle_exit_ena = sta_is_idle & start;
assign state_idle_nxt = STATE_1ST;

assign state_1st_exit_ena = sta_is_1st & t_cnt_eq_water_in_1st;
assign state_1st_nxt = STATE_2ND;

assign state_2nd_exit_ena = sta_is_2nd & n_cnt_eq_rep_1st;
assign state_2nd_nxt = STATE_3RD;

wire [CNT_W-1:0] n_cnt;
wire [CNT_W-1:0] t_cnt;
// wire [CNT_W-1:0] d_cnt; // delay count
wire rot_compl_n;
reg [STATE_W-1:0] state;
reg [STATE_W-1:0] next;
// wire clear;
// reg clear_reg;

counter #(.WIDTH(CNT_W))    cn	(	.clk(clk),
			                        .rst_n(clear),
			                        .cnt(n_cnt));

counter #(.WIDTH(CNT_W))    ct	(	.clk(clk),
			                        .rst_n(clear),
			                        .cnt(t_cnt));

// counter #(.WIDTH(CNT_W))    cd  (   .clk(clk),
//                                     .rst_n(cd_clear)
//                                     .cnt(d_cnt));

rotate                      r0  (   .clk(clk),
                                    .rst_n(rst_n),
                                    .motor(motor),
                                    .compl_n(rot_compl_n));

assign cd_clear = ~rot_compl_n;

// assign motor = {SW{rst_n}} &   (state == S1 ? M1 :
//                                 state == S2 ? M0 :
//                                 state == S3 ? M2 :
//                                 state == S4 ? M0 : M0);

assign clear = rst_n & over;

assign next =  (state == S1 && t_cnt == WATER_IN_1 ? S2 :
                state == S2 && n_cnt == REP_1 ? S3 :
                state == S3 && t_cnt == WATER_OUT_1 ? S4 :
                state == S4 && cnt == PAUSE ? S0 : state);

assign over =  (state == S1 && t_cnt == WATER_IN_1 ? 0 :
//                 state == S2 && cnt == PAUSE ? 0 :
//                 state == S3 && cnt == CCW   ? 0 :
//                 state == S4 && cnt == PAUSE ? 0 : 1);

// assign compl_n = (state != S0);

always@(posedge clk) begin
    if (~rst_n)
        state <= STATE_IDLE;
    else
        state <= next;
end

endmodule