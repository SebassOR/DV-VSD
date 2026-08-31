module top #(
	//parameter [7:0] bin = 8'd000
	//parameter [7:0] bin = 8'd042
	//parameter [7:0] bin = 8'd064
	//parameter [7:0] bin = 8'd144
	//parameter [7:0] bin = 8'd164
	//parameter [7:0] bin = 8'd255

)(

	input  logic [7:0] binary,
	output logic [6:0] segments_hundreds,
	output logic [6:0] segments_tens,
	output logic [6:0] segments_units
);

	logic [3:0] bcd_units, bcd_tens, bcd_hundreds;

	
	BCD_Converter u_bcd (
		.binary  (binary),
		.units   (bcd_units),
		.tens    (bcd_tens),
		.hundreds(bcd_hundreds)
	);

	
	SevenSegDecoder u_seg_units    
	(.num(bcd_units),   
	.seg(segments_units));
	
	SevenSegDecoder u_seg_tens    
	(.num(bcd_tens),     
	.seg(segments_tens));
	
	SevenSegDecoder u_seg_hundreds 
	(.num(bcd_hundreds), 
	.seg(segments_hundreds));

endmodule