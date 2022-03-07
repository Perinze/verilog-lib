module mux (
    input s,
    input da,
    input db,
    output out
);

assign out = s ? db : da;

endmodule