module UART_tb();
reg clk, arst_n;
reg [7:0] data;
reg uart_en;
wire [7:0] received_data;
wire TX_busy, TX_done, RX_busy, RX_done, RX_error;
UART uut
(
	.clk(clk),
	.arst_n(arst_n),
	.data(data),
	.uart_en(uart_en),
	.received_data(received_data),
	.TX_busy(TX_busy),
	.TX_done(TX_done),
	.RX_busy(RX_busy),
	.RX_done(RX_done),
	.RX_error(RX_error)
);
initial
	#50_000_000 $finish;
localparam T = 10;
always
begin
	clk = 1'b0;
#(T/2)
	clk = 1'b1;
#(T/2);
end
initial
begin
	arst_n = 1'b0;
	uart_en = 1'b0;
#2
	arst_n = 1'b1;
	uart_en = 1'b1;
	repeat(2)@(negedge clk)
	data = 8'b11010011;
	wait(RX_done == 1);
	#100 $stop;
end
endmodule
