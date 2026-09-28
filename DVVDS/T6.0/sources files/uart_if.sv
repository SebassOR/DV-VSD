interface uart_if (
    input logic clk,
    input logic rst
);
    logic       rx;
    logic [7:0] rx_data;
    logic       received;
    logic       parity_error;
endinterface