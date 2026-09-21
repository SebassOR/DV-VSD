`timescale 1ns/1ps

module uart_rx_tb;
    localparam int    TB_CLKS_PER_BIT = 5;
    logic       clk = 0;
    logic       rst;
    logic       rx = 1'b1; 
    logic [7:0] rx_data;
    logic       received;
    logic       parity_error;
    int errors = 0;
    
    
    always #5 clk = ~clk;
    
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

logic [7:0] expected_data_q  [$];
logic       expected_error_q [$];
logic [7:0] exp_data;
logic       exp_err;

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
    expected_data_q.push_back(data);
    expected_error_q.push_back(expect_err);
    send_byte(data, parity_kind);
        
endtask

initial begin
        rst = 1'b1;
        repeat (3) @(posedge clk);
        rst = 1'b0;
        @(posedge clk);
        send_and_expect(8'b00000000, "EVEN", 1'b0);
        send_and_expect(8'b01010001, "EVEN", 1'b0);
        send_and_expect(8'b01101001, "EVEN", 1'b0);
        send_and_expect(8'b01111111, "EVEN", 1'b0);
        send_and_expect(8'b01010001, "ODD",  1'b1);
        repeat (20) @(posedge clk);

        if (errors == 0)
            $display("\nALL TESTS PASSED \n");
        else
            $display("\n%0d TEST(S) FAILED\n", errors);

        $finish;
    end

endmodule