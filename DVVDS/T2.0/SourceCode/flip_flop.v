module flip_flop (

    input       clock,

    input       reset_n,

    input       enable,

    input [3:0] D_in,

    output reg [3:0] Q  // Debe ser reg porque se asigna dentro de un always

);

    always @(posedge clock or negedge reset_n) begin

        if (!reset_n) begin

            Q <= 4'b0000;

        end else if (enable) begin

            Q <= D_in;

        end

    end

endmodule