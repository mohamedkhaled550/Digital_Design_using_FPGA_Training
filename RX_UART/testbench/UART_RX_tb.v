module UART_RX_tb();
    reg clk, areset_n, RX, rx_en;
    wire [7:0] data;
    wire done, err, busy;
	UART_RX uut (
        .clk(clk),
        .areset_n(areset_n),
        .RX(RX),
        .rx_en(rx_en),
        .done(done),
        .err(err),
        .busy(busy),
        .data(data)
    );
    // Clock generation (100 MHz)
    localparam T = 10; // 10 ns ? 100 MHz
    always #(T/2) clk = ~clk;
    // UART parameters
    localparam BAUD = 9600;
    localparam CLK_FREQ = 100_000_000;
    localparam integer BIT_PERIOD = CLK_FREQ / BAUD; // ~10416 cycles
    // Task to send one byte over RX
    task send_byte(input [7:0] byte);
        integer i;
        begin
            // Start bit
            RX = 0; #(BIT_PERIOD*T);
            // Data bits (LSB first)
            for (i = 0; i < 8; i = i+1) begin
                RX = byte[i];
                #(BIT_PERIOD*T);
            end
            // Stop bit
            RX = 1; #(BIT_PERIOD*T);
        end
    endtask
    initial begin
        clk = 0;
        RX = 1;        // idle
        areset_n = 0;
        rx_en = 0;
        #(5*T);
        areset_n = 1;
        rx_en = 1;
        #(5*T);
        // Send 0xA5 = 1010_0101
        send_byte(8'b01011010);
        // Wait a bit to observe "done"
        #(BIT_PERIOD*T*2);
        $stop;
	end
endmodule
