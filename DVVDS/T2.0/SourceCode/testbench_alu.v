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

    //estimulo
    initial begin
        @(negedge clk);
        reset = 1'b0;      

        @(negedge clk); sela = 3'b000; // AND
        @(negedge clk); sela = 3'b001; // OR
        @(negedge clk); sela = 3'b010; // NOT
        @(negedge clk); sela = 3'b011; // XOR
        @(negedge clk); sela = 3'b100; // ADD
        @(negedge clk); sela = 3'b101; // SUB
        @(negedge clk); sela = 3'b110; // NEG
        @(negedge clk); sela = 3'b111; // MUL
    end

endmodule