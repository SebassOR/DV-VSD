module handshaking(
    input  logic clkA,    
    input  logic clkB,    
    input  logic rst_n,
    input  logic signal_i, 
    output logic signal_o, 
    output logic busy_o   
);
    logic a1_q;            
    logic a3_q;            
    logic b2_q;           
    logic mux1_o, mux2_o;
    assign mux1_o = a3_q ? 1'b0 : a1_q;
    assign mux2_o = signal_i ? 1'b1 : mux1_o;
    always_ff @(posedge clkA or negedge rst_n) begin
        if (!rst_n) a1_q <= 1'b0;
        else        a1_q <= mux2_o;
    end
    OneShot u_oneshot (
        .clk    (clkB),
        .rst_n  (rst_n),
        .data_i (a1_q),
        .sync_o (b2_q),     
        .data_o (signal_o)
    );

    DoubleFlop u_doubleflop (
        .clk    (clkA),
        .rst_n  (rst_n),
        .data_i (b2_q),
        .data_o (a3_q)
    );

    assign busy_o = a1_q | a3_q;

endmodule

module DoubleFlop(
    input clk, // Destination clock
    input rst_n,
    input data_i,
    output data_o
);

logic meta_stable_data, clean_data;

always_ff@(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        {clean_data, meta_stable_data} <= 2'b00;
    end
    else begin
        {clean_data, meta_stable_data} <= {meta_stable_data, data_i};
    end
end

assign data_o = clean_data;

endmodule

module OneShot(
    input clk, // Destination clock
    input rst_n,
    input data_i,
    output sync_o, 
    output data_o
);

logic meta_stable_data, clean_data, delayed_data;

always_ff@(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        {delayed_data, clean_data, meta_stable_data} <= 3'b000;
    end
    else begin
        {delayed_data, clean_data, meta_stable_data} <= {clean_data, meta_stable_data, data_i};
    end
end

assign sync_o = clean_data;
assign data_o = ~delayed_data & clean_data;

endmodule