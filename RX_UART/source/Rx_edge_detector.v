module Rx_edge_detector
(
	input clk, areset_n,
	input rx,
	output n_edge, p_edge
);
localparam  s0 = 0, s1 = 1;
reg state_reg, state_next;
always @(posedge clk , negedge areset_n)
begin
	if(!areset_n)
		state_reg <= s0;
	else
		state_reg <= state_next;
end
always @(*)
begin
	case(state_reg)
		s0: state_next = rx? s1:s0;
		s1: state_next = rx? s1:s0;
		default: state_next = s0;
	endcase
end
assign n_edge = (state_reg == s1) & ~rx;
assign p_edge = (state_reg == 1);
endmodule