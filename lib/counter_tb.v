module counter_tb;
    parameter WIDTH     = 16;
    parameter FREQ      = 40_000;
    parameter PERIOD    = 1_000;

    reg                 clk;    // 40kHz
    reg                 rstn;
    wire    [WIDTH-1:0] cnt;

    counter c0  (   .clk    (clk),
                    .rstn   (rstn),
                    .cnt    (cnt));
    initial begin            
        $dumpfile("counter.vcd");
        $dumpvars(0, counter_tb);
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