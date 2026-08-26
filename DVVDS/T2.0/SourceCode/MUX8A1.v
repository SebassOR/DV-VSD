module MUX8A1(
    input  wire [3:0] I0, I1, I2, I3, I4, I5, I6, I7,
    input  wire [2:0] S,
    output wire [3:0] Y
);

// Señales internas
wire [3:0] Y0, Y1, Y2, Y3, Y4, Y5;                   //conectores de salidas


// Primera etapa: 4 multiplexores de 2 entradas
MUX2to1 mux0(                                      //instanciamos el modulo
    .I0(I0),                                    //puerto del modulo MUX2 y MUX8A1
    .I1(I1),
    .S(S[0]),
    .Y(Y0)
);

MUX2to1 mux1(
    .I0(I2),
    .I1(I3),
    .S(S[0]),
    .Y(Y1)
);

MUX2to1 mux2(
    .I0(I4),
    .I1(I5),
    .S(S[0]),
    .Y(Y2)
);

MUX2to1 mux3(
    .I0(I6),
    .I1(I7),
    .S(S[0]),
    .Y(Y3)
);

// Segunda etapa: 2 multiplexores de 2 entradas
MUX2to1 mux4(
    .I0(Y0),
    .I1(Y1),
    .S(S[1]),
    .Y(Y4)
);

MUX2to1 mux5(
    .I0(Y2),
    .I1(Y3),
    .S(S[1]),
    .Y(Y5)
);

// Tercera etapa: 1 multiplexor de 2 entradas
MUX2to1 mux6(
    .I0(Y4),
    .I1(Y5),
    .S(S[2]),
    .Y(Y)
);

endmodule
