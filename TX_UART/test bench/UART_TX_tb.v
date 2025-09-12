module UART_TX_tb();
reg clk, arst_n, rst, tx_en;
reg [7:0] data;
wire tx, done, busy;
UART_TX uut
(
	.clk(clk),
	.arst_n(arst_n),
	.rst(rst),
	.tx_en(tx_en),
	.data(data),
	.tx(tx),
	.done(done),
	.busy(busy)
);
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
	rst = 1;
	tx_en = 1'b0;
#2
	arst_n = 1'b1;
	rst = 0;
	tx_en = 1'b1;
@(negedge clk)
	data = 8'b01101010;
wait(done == 1)
#20 
@(negedge clk)
	data = 8'b01011011;
wait(done == 1)
#100 $stop;
end
endmodule
