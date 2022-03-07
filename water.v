module water (
    input s,
    output in,
    output out
);

assign in = s ? 0 : 1;
assign out = s ? 1 : 0;

endmodule