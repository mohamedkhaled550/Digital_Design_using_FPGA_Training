module Rx_FSM
(
	input clk, areset_n, en, reset,
	input R_bit, P_bit, counter_tick,
	output reg SIPO_en,
	output done, err, busy 
);
localparam [2:0] IDLE = 0,
		 START = 1,
		 DATA = 2,
		 STOP = 3,
		 DONE = 4,
		 ERR = 5;
reg [3:0] s_reg, s_next;
reg [2:0] n_reg, n_next;
reg [2:0] state_reg, state_next;
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
	else if(en)
	begin
		s_reg <= s_next;
		n_reg <= n_next;
		state_reg <= state_next;
	end
	else
	begin
		s_reg <= s_reg;
		n_reg <= n_reg;
		state_reg <= state_reg;
	end
end
always @(*)
begin
SIPO_en = 0;
state_next = state_reg;
s_next = s_reg;
n_next = n_reg;
	case(state_reg)
		IDLE: if(R_bit)begin
				s_next = 0;
				state_next = START;
			end
			else
				state_next = IDLE;
		START: if(counter_tick)
			if(s_reg == 7)begin
				s_next = 0;
				n_next = 0;
				state_next = DATA;
			end
			else begin
				s_next = s_reg + 1;
				state_next = START;
			end
		DATA: if(counter_tick)
			if(s_reg == 15)begin
				SIPO_en = 1;
				s_next = 0;
				if(n_reg == 7)
					state_next = STOP;
				else begin
				n_next = n_reg + 1;
				state_next = DATA;
				end
			end
			else begin
				s_next = s_reg + 1;
				state_next = DATA;
			end
		STOP: if(counter_tick)
			if(s_reg == 15)
					if(P_bit)
						state_next = DONE;
					else
						state_next = ERR;
			else begin
				s_next = s_reg + 1;
				state_next = STOP;
			end
		else
			state_next = STOP;
		DONE: state_next = IDLE;
		ERR: state_next = IDLE;
		default: state_next = IDLE;
	endcase
end
assign done = (state_reg == DONE);
assign err = (state_reg == ERR);
assign busy = (state_reg != IDLE);
endmodule
