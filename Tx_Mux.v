module Tx_Mux
(
	input [9:0] frame,
	input [3:0] sel,
	output reg f
);
always @(*)
begin
	case(sel)
		4'b0000: f = frame[0];
		4'b0001: f = frame[1];
		4'b0010: f = frame[2];
		4'b0011: f = frame[3];
		4'b0100: f = frame[4];
		4'b0101: f = frame[5];
		4'b0110: f = frame[6];
		4'b0111: f = frame[7];
		4'b1000: f = frame[8];
		4'b1001: f = frame[9];
		default: f = frame[0];
	endcase
end
endmodule
