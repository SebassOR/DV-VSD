module RAM_SYNC #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16,
    parameter ADDR_WIDTH = (FIFO_DEPTH <= 1) ? 1: $clog2(FIFO_DEPTH)

)(
    input clk,
    input reset,
    input write_enable,
    input read_enable,
    input [ADDR_WIDTH-1:0] write_address,
    input [ADDR_WIDTH-1:0] read_address,
    input [DATA_WIDTH-1:0] data_in,
    output logic [DATA_WIDTH-1:0] data_out  
);

logic [DATA_WIDTH-1:0] mem [0:FIFO_DEPTH-1];

always_ff @(posedge clk) begin
    if (reset) begin
        data_out <= '0;
    end else begin
        if (write_enable) begin
            mem[write_address] <= data_in;
        end
        if (read_enable) begin
            data_out <= mem[read_address];
        end
    end
end
endmodule