module top (
    input  CLOCK_50, 
    output [3:0] LEDR,      
    output       ledclk
);
    wire       clk;
    wire [3:0] Result;
    wire [2:0] selector;
    wire [3:0] A_in, B_in;

    assign clk    = CLOCK_50;
    assign ledclk = clk;


    //Caso AND: 1011 & 0000 = 0000
    //assign selector = 3'b000; assign A_in = 4'b1011; assign B_in = 4'b0000;

    //Caso OR: 0010 | 0110 = 0110
    //assign selector = 3'b001; assign A_in = 4'b0010; assign B_in = 4'b0110;

    //Caso NOT: ~0000 = 1111 
    //assign selector = 3'b010; assign A_in = 4'b0000; assign B_in = 4'b0000;

    //Caso XOR: 0110 ^ 1011 = 1101
    //assign selector = 3'b011; assign A_in = 4'b0110; assign B_in = 4'b1011;

    //Caso ADD: 0000 + 0010 = 0010
    //assign selector = 3'b100; assign A_in = 4'b0000; assign B_in = 4'b0010;

    //Caso SUB: 1011 - 0000 = 1011
    //assign selector = 3'b101; assign A_in = 4'b1011; assign B_in = 4'b0000;

    //Caso NEG: -0010 = 1110
    //assign selector = 3'b110; assign A_in = 4'b0010; assign B_in = 4'b0000;

    //Caso MUL: 0000 * 0000 = 0000
    assign selector = 3'b111; assign A_in = 4'b0000; assign B_in = 4'b0000;

		//en esta parte deje el reset y el disable para los flipflops porque mi tarjeta me daba bronca un boton.
    wire [3:0] Q_A, Q_B;
    flip_flop M1 (
			.D_in(A_in), 
			.enable(1'b1), 
			.clock(clk), 
			.reset_n(1'b1), 
			.Q(Q_A)
		);
			
    flip_flop M2 (
		 .D_in(B_in), 
		 .enable(1'b1), 
		 .clock(clk), 
		 .reset_n(1'b1), 
		 .Q(Q_B));

    // ALU
    wire [3:0] AND_w, OR_w, NOT_w, XOR_w, ADD_w, SUB_w, NEG_w, MUL_w;
    ALU M3 (
		 .A(Q_A), 
		 .B(Q_B), 
		 .AND(AND_w), 
		 .OR(OR_w), 
		 .ALT(NOT_w), 
		 .XOR(XOR_w),
       .ADD(ADD_w), 
		 .SUB(SUB_w), 
		 .NEG(NEG_w), 
		 .MUL(MUL_w));

    // MUX
    MUX8A1 M4 (
	 .I0(AND_w), 
	 .I1(OR_w), 
	 .I2(NOT_w), 
	 .I3(XOR_w),
    .I4(ADD_w), 
	 .I5(SUB_w), 
	 .I6(NEG_w), 
	 .I7(MUL_w),
    .S(selector), 
	 .Y(Result)
	 );

   assign LEDR = Result;
endmodule