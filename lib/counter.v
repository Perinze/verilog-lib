module counter # (
	parameter WIDTH = 16
) (
	input clk,
	input rst_n,
	output reg [WIDTH-1:0] cnt
);

always @(posedge clk) begin
	if (rst_n == 0)
		cnt <= {WIDTH{1'b0}};
	else
		cnt <= cnt + 1;
end

endmodule
