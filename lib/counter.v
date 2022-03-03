module counter # (
	parameter WIDTH = 16
) (
	input clk,
	input rstn,
	output reg [WIDTH-1:0] cnt
);

always @(posedge clk) begin
	if (rstn == 1'b0)
		cnt <= {WIDTH{1'b0}};
	else
		cnt <= cnt + 1;
end

endmodule