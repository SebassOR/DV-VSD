module top (
    input [3:0] A_in,        
    input Disable,          
    input clk,  
    input reset_n,  
    input [3:0] B_in,
    input [2:0]selector,      

    output [3:0] Result            
);

    wire [3:0] Q_A;
    wire [3:0] Q_B;
    wire [3:0] AND_w; // A & B
    wire [3:0] OR_w;  // A | B    
    wire [3:0] NOT_w; // ~A    
    wire [3:0] XOR_w;  // A ^ B    
    wire [3:0] ADD_w; // A + B    
    wire [3:0] SUB_w; // A - B
    wire [3:0] NEG_w; // - A        
    wire [3:0] MUL_w; // A * B

    // Estas declaraciones se pueden realizar tamben de la siguiente manera con
    // la ventaja de poder cambiar el numero de bits desde un solo lugar ( [N-1:0] ) y además
    // de poder almacenar los wires en un solo arreglo ( RAlu[7:0] ):
    // wire [N-1:0] Q_A, Q_B;
    // wire [N-1:0] RAlu[7:0];

    wire enable;

    assign enable = ~Disable;

    flip_flop M1 (
        .D_in(A_in),
        .enable(~Disable),
        .clk(clock),
        .reset_n(reset_n),
        .Q(Q_A)
    );

    flip_flop M2 (
        .D_in(B_in),
        .enable(enable),
        .clock(clock),
        .reset_n(reset_n),
        .Q(Q_B)
    );

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
        .MUL(MUL_w)
    );

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

endmodule