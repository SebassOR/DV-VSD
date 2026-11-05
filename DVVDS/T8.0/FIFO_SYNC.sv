module FIFO_SYNC # (
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16
)(
    input [DATA_WIDTH-1:0] DataInput,
    input clk,
    input reset,
    input push,
    input pop,

    output [DATA_WIDTH-1:0] DataOutput,
    output logic full,
    output logic empty
);
    localparam ADDR_WIDTH = (FIFO_DEPTH <= 1) ? 1 : $clog2(FIFO_DEPTH);
    localparam COUNT_WIDTH = (FIFO_DEPTH <= 1) ? 1 : $clog2(FIFO_DEPTH + 1);
    logic [ADDR_WIDTH-1:0] write_pointer;
    logic [ADDR_WIDTH-1:0] read_pointer;
    logic [COUNT_WIDTH-1:0] item_count;
    logic accepted_push;
    logic accepted_pop;

    assign full = (item_count == FIFO_DEPTH);
    assign empty = (item_count == 0);
    assign accepted_push = push && !full;
    assign accepted_pop = pop && !empty;

    RAM_SYNC #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) memory (
        .clk(clk),
        .reset(reset),
        .write_enable(accepted_push),
        .read_enable(accepted_pop),
        .write_address(write_pointer),
        .read_address(read_pointer),
        .data_in(DataInput),
        .data_out(DataOutput)
    );

    always_ff @(posedge clk) begin
        if (reset) begin
            write_pointer <= '0;
            read_pointer <= '0;
            item_count <= '0;
        end else begin
            if (accepted_push) begin
                if (write_pointer == FIFO_DEPTH - 1)
                    write_pointer <= '0;
                else
                    write_pointer <= write_pointer + 1'b1;
            end
            if (accepted_pop) begin
                if (read_pointer == FIFO_DEPTH - 1)
                    read_pointer <= '0;
                else
                    read_pointer <= read_pointer + 1'b1;
            end
            case ({accepted_push, accepted_pop})
                2'b10: item_count <= item_count + 1'b1;
                2'b01: item_count <= item_count - 1'b1;
                default: item_count <= item_count;
            endcase
        end
    end
endmodule
