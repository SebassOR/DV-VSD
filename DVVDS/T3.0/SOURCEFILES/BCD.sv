module BCD_Converter #(
	parameter [7:0] bin = 8'd0
)(
	
	output logic [3:0] units,
	output logic [3:0] tens,
	output logic [3:0] hundreds
);

	logic [19:0] stage [0:8];

	assign stage[0] = {12'b0, bin};

	stp_BCD step0 
		(.INs(stage[0]), 
		.OUTs(stage[1]));
	stp_BCD step1 
		(.INs(stage[1]), 
		.OUTs(stage[2]));
	stp_BCD step2 
		(.INs(stage[2]), 
		.OUTs(stage[3]));
	stp_BCD step3 
		(.INs(stage[3]), 
		.OUTs(stage[4]));
	stp_BCD step4 
		(.INs(stage[4]), 
		.OUTs(stage[5]));
	stp_BCD step5 
		(.INs(stage[5]), 
		.OUTs(stage[6]));
	stp_BCD step6 
		(.INs(stage[6]), 
		.OUTs(stage[7]));
	stp_BCD step7 
		(.INs(stage[7]), 
		.OUTs(stage[8]));

			assign units    = stage[8][11:8];
			assign tens     = stage[8][15:12];
			assign hundreds = stage[8][19:16];

endmodule

module stp_BCD (
	input  logic [19:0] INs,
	output logic [19:0] OUTs
);

	logic [3:0] units_adj, tens_adj, hundreds_adj;

	always_comb begin
		// add-3 si el dígito actual es >= 5
		units_adj    = (INs[11:8]  >= 5) ? (INs[11:8]  + 4'd3) : INs[11:8];
		tens_adj     = (INs[15:12] >= 5) ? (INs[15:12] + 4'd3) : INs[15:12];
		hundreds_adj = (INs[19:16] >= 5) ? (INs[19:16] + 4'd3) : INs[19:16];

		// shift left de todo el registro (digitos ajustados + bits de binario)
		OUTs = {hundreds_adj, tens_adj, units_adj, INs[7:0]} << 1;
	end

endmodule