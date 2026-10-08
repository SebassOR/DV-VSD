`timescale 1ns/1ps

module mediana_tb;

    logic [7:0] a, b, c, d;
    logic [7:0] med;

    mediana dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .med(med)
    );

    initial begin
        a = 10; b = 20; c = 30; d = 40;
    end
endmodule