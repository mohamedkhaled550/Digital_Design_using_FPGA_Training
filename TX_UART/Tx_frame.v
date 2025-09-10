module Tx_frame
(
	input clk, areset_n,
	input [7:0] data,
	output [9:0] out_data
);
reg [9:0] Q_reg, Q_next;
always @(posedge clk, negedge areset_n)
begin
	if(!areset_n)
		Q_reg <= 10'b1111111111;
	else
		Q_reg <= Q_next;
end
always @(*)
begin
	Q_next = {1'b1,data[7:0],1'b0};
end
assign out_data = Q_reg;
endmodule