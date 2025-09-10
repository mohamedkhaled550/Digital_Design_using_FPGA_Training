module SIPO_shift_register
(
	input clk, areset_n, en,
	input S_input,
	output [7:0] Q
);
reg [7:0] Q_reg, Q_next;
always @(posedge clk, negedge areset_n)
begin
	if(!areset_n)
		Q_reg <= 8'b0;
	else if(en)
		Q_reg <= Q_next;
	else
		Q_reg <= Q_reg;
end
always @(*)
begin
	Q_next = {S_input, Q_reg[7:1]};
end
assign Q = Q_reg;
endmodule