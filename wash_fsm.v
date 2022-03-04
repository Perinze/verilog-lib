module wash_fsm # (
    paramtere WIDTH = 5,
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
    input clk,
    input rst_n,
    input start,
    input [WIDTH-1:0] cnt,
    // 0 for stop, 1 for clockwise, 2 for counterclockwise, 3 undefined
    output reg [2:0] motor,
    // 0 for stopping, 1 for working
    // negedge indicate completion
    output compl_n,
    output clear
);

wire reg [2:0] state;

assign motor = (state == S1 ? M1 :
                state == S2 ? M0 :
                state == S3 ? M2 :
                state == S4 ? M0 : M0);

assign compl_n = (  state == S1 ? 1 :
                    state == S2 ? 1 :
                    state == S3 ? 1 :
                    state == S4 ? 1 : 0);

always@(posedge clk) begin
    if (~rst_n) begin
        state <= S0;
        compl_n <= 0;
        clear <= 0;
    end
    case(state)
        S1: begin
            state <= (cnt == CW ? S2 : state);
            clear <= (cnt == CW ? 1 : 0);
        end
        S2: begin
            state <= (cnt == PAUSE ? S3 : state);
            clear <= (cnt == PAUSE ? 1 : 0);
        end
        S3: begin
            state <= (cnt == CCW ? S4 : state);
            clear <= (cnt == CCW ? 1 : 0);
        end
        S4: begin
            state <= (cnt == PAUSE ? S0 : state);
            clear <= (cnt == PAUSE ? 1 : 0);
        end
        default: begin
            state <= S0;
            clear <= 0;
        end
    endcase
end

endmodule