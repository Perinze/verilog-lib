module clk_div # (
	parameter WIDTH = 16,
	parameter N = 20_000
	//parameter N = 4
) (
	input clk,			// suppose input 40kHz
	input rst_n,
	input [WIDTH-1:0] cnt,
	output reg clk_out,
	output reg cnt_rst_n
);

always @(posedge clk) begin
	if (rst_n == 1'b0)
		clk_out <= 0;
	else if (cnt == N-1) begin
		clk_out <= ~clk_out;
		cnt_rst_n <= 0;
	end
	else
		cnt_rst_n <= 1;
end

endmodule
