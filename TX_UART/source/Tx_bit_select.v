module Tx_bit_select
(
	input clk, areset_n, tx_en, reset,
	input counter_tick,
	output reg [3:0] sel,
	output reg load, done,
	output busy 
);
localparam [2:0] IDLE = 0,
		 SELECT = 1;
reg [3:0] s_reg, s_next;
reg [3:0] n_reg, n_next;
reg state_reg, state_next; 
always @(posedge clk, negedge areset_n)
begin
	if(!areset_n)
	begin
		s_reg <= 4'b0000;
		n_reg <= 3'b000;
		state_reg <= IDLE;
	end
	else if(reset)
		begin
		s_reg <= 4'b0000;
		n_reg <= 3'b000;
		state_reg <= IDLE;
	end
	else
	begin
		s_reg <= s_next;
		n_reg <= n_next;
		state_reg <= state_next;
	end
end
always @(*)
begin
state_next = state_reg;
s_next = s_reg;
n_next = n_reg;
done = 1'b0;
	case(state_reg)
	IDLE: begin
		load = 1'b0;
		sel = 1'b0;
		if(tx_en)begin
			s_next = 0;
			n_next = 0;
			state_next = SELECT;
		end
		else
			state_next = IDLE;
	end
	SELECT:begin
		load = 1'b1;
		sel = n_reg;
		if(counter_tick)
			if(s_reg == 15)begin
				s_next = 0;
				if(n_reg == 9)begin
					done = 1'b1;
					state_next = IDLE;
				end
				else begin
					n_next = n_next + 1;
					state_next = SELECT;
				end
			end
			else begin
				s_next = s_reg + 1;
				state_next = SELECT;
			end
	end
	endcase
end
assign busy = (state_reg == SELECT);
endmodule
