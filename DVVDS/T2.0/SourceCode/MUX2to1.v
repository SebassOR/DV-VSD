module MUX2to1(
    input  wire [3:0] I0,
    input  wire [3:0] I1,
    input  wire        S,
    output wire [3:0] Y
);

    assign Y = (~S & I0) | (S & I1);

endmodule