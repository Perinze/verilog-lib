module counter # (
	parameter WIDTH = 16
) (
	input clk,
	input clear,
	output reg [WIDTH-1:0] cnt
);

always @(posedge clk) begin
	if (~clear)
		cnt <= {WIDTH{1'b0}};
	else
		cnt <= cnt + 1;
end

endmodule
