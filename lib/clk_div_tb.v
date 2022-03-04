module clk_div_tb;
    parameter WIDTH     = 16;
    parameter FREQ      = 40_000;
    parameter PERIOD    = 1_000;

    reg     clk;    // 40kHz
    reg     rstn;
    wire    [WIDTH-1:0] cnt;
    wire    clk_out;
    wire    cnt_rstn;

    assign  counter_rstn    = rstn & cnt_rstn;

    counter c0  (   .clk(clk),
                    .rstn(rstn),
                    .cnt(cnt));

    clk_div cd0 (   .clk    (clk),
                    .rstn   (rstn),
                    .cnt    (cnt),
                    .clk_out(clk_out),
                    .cnt_rstn(cnt_rstn));

    initial begin            
        $dumpfile("clk_div.vcd");
        $dumpvars(0, clk_div_tb);
    end

    // always #(500_000_000 / FREQ)
    always #1
        clk     <= ~clk;

    initial begin
        clk         <= 1'b0;
        rstn        <= 1'b0;

        #2  rstn    <= 1'b1;

        #PERIOD $finish;
    end

endmodule