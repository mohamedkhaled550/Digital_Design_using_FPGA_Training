module UART_TX
(
	input clk, arst_n, tx_en, rst,
	input [7:0] data,
	output tx, done, busy
);
wire tick, load ;
wire [9:0] mux_in;
wire [3:0] sel;
Tx_bit_select bit_select
(
	.clk(clk),
	.areset_n(arst_n),
	.reset(rst),
	.tx_en(tx_en),
	.counter_tick(tick),
	.sel(sel),
	.load(load),
	.done(done),
	.busy(busy)
);
Tx_frame frame
(
	.clk(clk),
	.areset_n(load),
	.data(data),
	.out_data(mux_in)
);
baud_conuter counter
(
	.clk(clk),	
	.areset_n(arst_n),
	.Final_value(650),
	.done(tick)
);
Tx_Mux MUX
(
	.frame(mux_in),
	.sel(sel),
	.f(tx)
);
endmodule
