/*
This module must set 1 shot, ONLY when 5 clock cycles in high are found in input.
inputs:
 c is clock of the system
 r is reset of the system (active low)
 i is the signal input.
output:
 o generates a pulse of one clock cycle when i was high during 5 clock cycles
*/

module SS_oneshot_five_cycles(
	input c,
	input r,
	input i,
	output o,
);

reg f1,f2,f3,f4,f5,f6;

always@(posedge c, negedge r) begin
	if(r) begin
		f1 = 1'b0;
		f2 = 1'b0;
		f3 = 1'b0;
		f4 = 1'b0;
		f5 = 1'b0;
		f6 = 1'b0;
	end
	else begin
		f1 = i;
		f2 = f1;
		f3 = f2;
		f4 = f3;
		f5 = f4;
		f6 = f5;
	end
end

assign o = f1 & f2 & f3 & f4 & f5 & !f6;


endmodule
