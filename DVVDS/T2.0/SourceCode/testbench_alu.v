`timescale 1ns/1ps

module testbench_alu;

    reg [2:0] sela  = 3'b000;
    reg reset = 1'b1;    
    reg clk   = 0;
    reg [3:0] a     = 4'b0000;
    reg [3:0] b     = 4'b0000;
    reg disable_reg = 1'b0;

    wire [3:0] out;

    // reloj: periodo de 4ns (toggle cada 2ns)
    always #2 clk = ~clk;

    ALUTOLEVEL DUV (
        .A_in(a),
        .B_in(b),
        .clock(clk),
        .reset(reset),
        .selector(sela),
        .out(out),
        .Disable(disable_reg)
    );

    //mi codigo de estudiante es 745984 usando la calculadora, en binario es 1011 0110 0010 0000 0000
    //estimulo
    initial begin
        @(negedge clk);
        reset = 1'b0;      
//casos
        //mul sel 7
        @(negedge clk); a = 4'b0000; b = 4'b0000; sela = 3'b111;
        @(negedge clk); 
        //neg sel 6
        @(negedge clk); a = 4'b1011; b = 4'b0000; sela = 3'b101;
        @(negedge clk);


    end

endmodule