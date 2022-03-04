module clk_1hz # (
    parameter WIDTH     = 16,
    parameter FREQ      = 40_000,
    parameter PERIOD    = 4_000_000_000
) (
    input   clk,	// 40Hz
    input   rst_n,	// 50000ns
    output  clk_out
);

wire    [WIDTH-1:0] cnt;
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

endmodule
