module UART_RX (
    input  logic       clk_50mhz,  
    input  logic       btn_rst,     
    input  logic       rx_pin,      
    output logic [7:0] led_data,    
    output logic       led_valid,   
    output logic       led_error    
);
    uart_rx #(
        .CLKS_PER_BIT(5),        
        .PARITY_MODE("ODD")      
    ) u_uart_rx (
        .clk(clk_50mhz),
        .rst(btn_rst),
        .rx(rx_pin),
        .rx_data(led_data),         
        .received(led_valid),       
        .parity_error(led_error)   
    );

endmodule