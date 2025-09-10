module baud_conuter
#(parameter Final_value_bits = 10)
(
	input clk, areset_n,
	input [Final_value_bits-1:0] Final_value,
	output done
);
reg [Final_value_bits-1:0] Q_reg, Q_next;
always @(posedge clk, negedge areset_n)
begin
	if(!areset_n)
		Q_reg <= {Final_value_bits{1'b0}};
	else
		Q_reg <= Q_next;
end
always @(*)
begin
	if(done)
		Q_next = {Final_value_bits{1'b0}};
	else
		Q_next = Q_reg + 1; 
end
assign done = (Q_reg == Final_value);
endmodule