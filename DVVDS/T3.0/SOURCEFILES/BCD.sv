module BCD (
 /*Mi entrada en binario*/
   input logic [7:0] binary,
 /*salidas BCD*/
	output logic [3:0] BCD0,
	output logic [3:0] BCD1,
	output logic [3:0] BCD2
);