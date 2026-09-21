module uart_rx #(
    parameter int    CLKS_PER_BIT = 5,      
    parameter string PARITY_MODE  = "NONE"
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


 logic rx_sync0, rx_sync1;
 wire  rx_bit = rx_sync1;

always_ff @(posedge clk) begin
        if (rst) begin
            rx_sync0 <= 1'b1;
            rx_sync1 <= 1'b1;
        end else begin
            rx_sync0 <= rx;
            rx_sync1 <= rx_sync0;
        end
    end

always_ff @(posedge clk) begin
        if (rst) begin
            state        <= S_IDLE;
            clk_count  <= '0;
            bit_index <= '0;
            rx_shift   <= '0;
            rx_data   <= '0;
            received <= 1'b0;
            parity_error <= 1'b0;
        end else begin
            received     <= 1'b0;
            case (state)

                S_IDLE: begin
                       clk_count <= '0;
                    bit_index <= '0;
                    if (rx_bit == 1'b0)      
                        state <= S_START;
                end
                S_START: begin
                   if (clk_count == (CLKS_PER_BIT-1)/2) begin
                        if (rx_bit == 1'b0) begin
                            clk_count <= '0;
                            state     <= S_DATA;
                        end else begin
                            state <= S_IDLE;  
                        end
                    end else begin
                        clk_count <= clk_count + 1'b1;
                    end
                end
                S_DATA: begin
                    if (clk_count < CLKS_PER_BIT-1) begin
                        clk_count <= clk_count + 1'b1;
                    end else begin
                        clk_count <= '0;
                        rx_shift  <= {rx_bit, rx_shift[7:1]};

                        if (bit_index < 3'd7) begin
                            bit_index <= bit_index + 1'b1;
                        end else begin
                            bit_index <= '0;
                            state <= (PARITY_MODE == "NONE") ? S_STOP : S_PARITY;
                        end
                    end
                end
                S_PARITY: begin
                if (clk_count < CLKS_PER_BIT-1) begin
                        clk_count <= clk_count + 1'b1;
                    end else begin
                        clk_count <= '0;
                        if (PARITY_MODE == "EVEN")
                            parity_error <= (^{rx_shift, rx_bit}) != 1'b0;
                        else 
                            parity_error <= (^{rx_shift, rx_bit}) != 1'b1;
                        state <= S_STOP;
                    end    
                end
                S_STOP: begin
                  if (clk_count < CLKS_PER_BIT-1) begin
                        clk_count <= clk_count + 1'b1;
                    end else begin
                        clk_count <= '0;
                        rx_data <= rx_shift;
                        state  <= S_CLEANUP;
                    end
                end
                S_CLEANUP: begin
                    received <= 1'b1;   
                    state    <= S_IDLE; 
                end
                default: state <= S_IDLE;
                endcase
        end
end
endmodule