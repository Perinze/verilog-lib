module mux_tb;

    reg a;
    reg b;
    reg s;
    wire out;

    mux m0 (.da(a),
            .db(b),
            .s(s),
            .out(out));

    initial begin            
        $dumpfile("mux.vcd");
        $dumpvars(0, mux_tb);
    end

    initial begin
        a <= 0;
        b <= 1;
        s <= 0;

        #(2) s <= 1;
        #(5) s <= 0;
        #(8) s <= 1;
        #(10) $finish;
    end

endmodule