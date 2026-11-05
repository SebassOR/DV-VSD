`timescale 1ns/1ps

module FIFO_SYNC_tb;
    localparam DATA_WIDTH = 8;
    localparam FIFO_DEPTH = 3;
    logic [DATA_WIDTH-1:0] DataInput;
    logic clk = 0;
    logic reset;
    logic push;
    logic pop;
    wire [DATA_WIDTH-1:0] DataOutput;
    wire full;
    wire empty;
    logic [DATA_WIDTH-1:0] reference_queue[$];
    logic [DATA_WIDTH-1:0] expected_output;
    logic accepted_push;
    logic accepted_pop;
    integer checks = 0;

    FIFO_SYNC #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) dut (
        .DataInput(DataInput),
        .clk(clk),
        .reset(reset),
        .push(push),
        .pop(pop),
        .DataOutput(DataOutput),
        .full(full),
        .empty(empty)
    );

    always #5 clk = ~clk;

    task automatic check_state(input string label);
        begin
            if (full !== (reference_queue.size() == FIFO_DEPTH)) begin
                $error("%s: full mismatch (got %b, expected %b)",
                    label, full, reference_queue.size() == FIFO_DEPTH);
                $fatal(1, "FAIL");
            end
            if (empty !== (reference_queue.size() == 0)) begin
                $error("%s: empty mismatch (got %b, expected %b)",
                    label, empty, reference_queue.size() == 0);
                $fatal(1, "FAIL");
            end
            if (DataOutput !== expected_output) begin
                $error("%s: data mismatch (got 0x%0h, expected 0x%0h)",
                    label, DataOutput, expected_output);
                $fatal(1, "FAIL");
            end
            checks = checks + 1;
        end
    endtask

    task automatic cycle(
        input logic do_push,
        input logic do_pop,
        input logic [DATA_WIDTH-1:0] data
    );
        begin
            @(negedge clk);
            push = do_push;
            pop = do_pop;
            DataInput = data;
            #1;

            accepted_push = do_push && (reference_queue.size() < FIFO_DEPTH);
            accepted_pop = do_pop && (reference_queue.size() > 0);
            if (accepted_pop)
                expected_output = reference_queue.pop_front();
            if (accepted_push)
                reference_queue.push_back(data);

            @(posedge clk);
            #1;
            check_state("despues de transaccion");
        end
    endtask

    initial begin
        reset = 1;
        push = 0;
        pop = 0;
        DataInput = '0;
        expected_output = '0;

        @(posedge clk);
        #1;
        reference_queue.delete();
        check_state("desp reset");

        @(negedge clk);
        reset = 0;
        cycle(0, 1, '0); 
        cycle(1, 0, 8'h11);
        cycle(1, 0, 8'h22);
        cycle(1, 0, 8'h33);
        cycle(1, 0, 8'h44); 
        cycle(1, 0, 8'h55);
        cycle(1, 1, 8'h66);      
        cycle(0, 1, '0);
        cycle(0, 1, '0);
        cycle(0, 1, '0);
        cycle(0, 1, '0);
        cycle(0, 1, '0);          

        cycle(1, 0, 8'hA1);
        cycle(1, 0, 8'hA2);
        cycle(0, 0, '0);
        cycle(1, 1, 8'hA3);     
        cycle(0, 1, '0);
        cycle(0, 1, '0);
        $finish;
    end
endmodule
