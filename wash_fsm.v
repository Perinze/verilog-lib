module wash_fsm # (
    parameter WIDTH = 5,
    parameter CW = 20,
    parameter CCW = 20,
    parameter PAUSE = 10,
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
    input start,
    // 0 for stop, 1 for clockwise, 2 for counterclockwise, 3 undefined
    output [1:0] motor,
    // 0 for stopping, 1 for working
    // negedge indicate completion
    output compl_n
);

wire [WIDTH-1:0] cnt;
reg [1:0] state;
wire clear;
reg clear_reg;

counter #(.WIDTH(WIDTH))    c0	(	.clk(clk),
			                        .rst_n(clear),
			                        .cnt(cnt));

assign motor = (state == S1 ? M1 :
                state == S2 ? M0 :
                state == S3 ? M2 :
                state == S4 ? M0 : M0);

assign compl_n = (  state == S1 ? 1 :
                    state == S2 ? 1 :
                    state == S3 ? 1 :
                    state == S4 ? 1 : 0);

assign clear = rst_n | clear_reg;

always@(posedge clk) begin
    if (~rst_n) begin
        state <= S0;
        compl_n <= 0;
        clear_reg <= 0;
    end
    case(state)
        S1: begin
            state <= (cnt == CW ? S2 : state);
            clear_reg <= (cnt == CW ? 1 : 0);
        end
        S2: begin
            state <= (cnt == PAUSE ? S3 : state);
            clear_reg <= (cnt == PAUSE ? 1 : 0);
        end
        S3: begin
            state <= (cnt == CCW ? S4 : state);
            clear_reg <= (cnt == CCW ? 1 : 0);
        end
        S4: begin
            state <= (cnt == PAUSE ? S0 : state);
            clear_reg <= (cnt == PAUSE ? 1 : 0);
        end
        default: begin
            state <= S0;
            clear_reg <= 0;
        end
    endcase
end

endmodule
