module mediana (  
    input  logic [7:0] a,b,c,d,
    output logic [7:0] med
);

logic [7:0] a1,b1,c1,d1;
logic [7:0] a2,b2,c2,d2;

always_comb begin

    //Etapa 1
    if (a < b) begin
        a1 = a; b1 = b;
    end else begin
        a1 = b; b1 = a;
    end

    if (c < d) begin
        c1 = c; d1 = d;
    end else begin
        c1 = d; d1 = c;
    end

    //Etapa 2
    if (a1 < c1) begin
        a2 = c1;
    end else begin
        a2 = a1;
    end

    if (b1 < d1) begin
        d2 = b1;
    end else begin
        d2 = d1;
    end

    //Mediana inferior
    if (a2 < d2)
        med = a2;
    else
        med = d2;

end

endmodule