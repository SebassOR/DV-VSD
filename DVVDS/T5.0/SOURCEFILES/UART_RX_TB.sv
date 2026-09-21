`timescale 1ns/1ps

module uart_rx_tb;
    localparam int    TB_CLKS_PER_BIT = 5;
    localparam string TB_PARITY_MODE  = "EVEN"; 
    logic       clk = 0;
    logic       rst;
    logic       rx = 1'b1; 
    logic [7:0] rx_data;
    logic       received;
    logic       parity_error;


     uart_rx #(
        .CLKS_PER_BIT(TB_CLKS_PER_BIT),
        .PARITY_MODE("EVEN")
    ) dut (
        .clk          (clk),
        .rst          (rst),
        .rx           (rx),
        .rx_data      (rx_data),
        .received     (received),
        .parity_error (parity_error)
    );
task automatic send_byte(input logic [7:0] data, input string parity_kind);
        int i;
        logic p;
        begin
    
        end
    endtask

task automatic send_and_expect(input logic [7:0] data, input string parity_kind,
                                    input logic expect_err);
    
        
endtask

endmodule