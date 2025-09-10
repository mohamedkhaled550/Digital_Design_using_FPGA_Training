module UART
(
	input clk, arst_n,
	input [7:0] data,
	input uart_en,
	output [7:0] received_data,
	output TX_busy,
	output TX_done,
	output RX_busy,
	output RX_done,
	output RX_error
);
wire TX;
UART_TX transmiter 
(
	.clk(clk),
	.arst_n(arst_n),
	.tx_en(uart_en),
	.data(data),
	.tx(TX),
	.done(TX_done),
	.busy(TX_busy)
);
UART_RX receiver
(
	.clk(clk),
	.areset_n(arst_n),
	.RX(TX),
	.rx_en(uart_en),
	.done(RX_done),
	.err(RX_error),
	.busy(RX_busy),
	.data(received_data)
);
endmodule
