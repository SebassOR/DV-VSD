module ALU(
input [3:0]A,
input [3:0]B,
output reg [3:0] AND,
output reg [3:0] OR,
output reg [3:0] ALT,
output reg [3:0] XOR,
output reg [3:0] ADD,
output reg [3:0] SUB,
output reg [3:0] NEG,
output reg [3:0] MUL
);

// Siempre que se tenga un cambio en las entradas, se calcula todo y se tienen las salidas.
always@(*) begin
    AND = A & B;       // AND
    OR  = A | B;       // OR
    ALT =~A    ;       // Negado
    XOR = A ^ B;       // XOR
    ADD = A + B;       // ADD
    SUB = A - B;       // SUB
    NEG =~A + 4'b0001; // Cambio de simbolo
    MUL = A * B;       // Multiplicacion
end
endmodule