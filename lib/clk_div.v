module clk_div # (
	parameter WIDTH = 16,
	//parameter N = 40_000,
	parameter N = 4
) (
	input clk,			// suppose input 40kHz
	input rstn,
	input [WIDTH-1:0] cnt,
	output reg clk_out,
	output reg cnt_rstn
);

always @(posedge clk) begin
	if (rstn == 1'b0)
		clk_out <= 0;
	else if (cnt == N-1) begin
		clk_out <= ~clk_out;
		cnt_rstn <= 0;
	end
	else
		cnt_rstn <= 1;
end

endmodule