module UART_RX
(
	input clk, arst_n, rst,
	input RX, rx_en,
	output done, err, busy,
	output [7:0] data
);
wire tick, start_bit, stop_bit, SIPO_en;
baud_conuter Timer 
(
	.clk(clk),
	.areset_n(arst_n),
	.Final_value(650),
	.done(tick)
);
Rx_edge_detector edge_detector
(
	.clk(clk),
	.areset_n(arst_n),
	.rx(RX),
	.n_edge(start_bit),
	.p_edge(stop_bit)
);
Rx_FSM FSM
(
	.clk(clk),
	.areset_n(arst_n),
	.reset(rst),
	.en(rx_en),
	.R_bit(start_bit),
	.P_bit(stop_bit),
	.counter_tick(tick),
	.SIPO_en(SIPO_en),
	.err(err),
	.busy(busy),
	.done(done)
);
SIPO_shift_register SIPO
(
	.clk(clk),
	.areset_n(arst_n),
	.en(SIPO_en),
	.S_input(RX),
	.Q(data)	
);
endmodule
