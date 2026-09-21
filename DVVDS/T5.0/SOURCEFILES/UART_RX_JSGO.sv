module uart_rx #(
    parameter int    CLKS_PER_BIT = 5,      
) (
    input  logic       clk,
    input  logic       rst,           
    input  logic       rx,            
 
    output logic [7:0] rx_data,       
    output logic        received,     
    output logic        parity_error                   
);

 typedef enum logic [2:0] {
        S_IDLE,
        S_START,
        S_DATA,
        S_PARITY,
        S_STOP,
        S_CLEANUP
    } state_t;

always_ff @(posedge clk) begin
        if (rst) begin
            rx_sync0 <= 1'b1;
            rx_sync1 <= 1'b1;
        end else begin
            rx_sync0 <= rx;
            rx_sync1 <= rx_sync0;
        end
    end