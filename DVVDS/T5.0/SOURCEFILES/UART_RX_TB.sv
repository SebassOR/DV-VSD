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
            // start bit
            rx = 1'b0;
            repeat (TB_CLKS_PER_BIT) @(posedge clk);
            // 8 data bits,
            for (i = 0; i < 8; i++) begin
                rx = data[i];
                repeat (TB_CLKS_PER_BIT) @(posedge clk);
            end
            // parity bit
            p = ^data; 
            if (parity_kind == "EVEN")
                rx = p;        
            else if (parity_kind == "ODD")
                rx = ~p;       
            else
                rx = 1'b1;    
            repeat (TB_CLKS_PER_BIT) @(posedge clk);
            // 2 stop bits
            rx = 1'b1;
            repeat (2*TB_CLKS_PER_BIT) @(posedge clk);
        end
    endtask

task automatic send_and_expect(input logic [7:0] data, input string parity_kind,
                                    input logic expect_err);
    
        
endtask

endmodule