`timescale 1ns/1ps

module tb_handshaking;
    logic clkA = 0;
    logic clkB = 0;
    logic rst_n;
    logic signal_i;
    logic signal_o;
    logic busy_o;
    int pulsos_o = 0;   

    handshaking dut (
        .clkA     (clkA),
        .clkB     (clkB),
        .rst_n    (rst_n),
        .signal_i (signal_i),
        .signal_o (signal_o),
        .busy_o   (busy_o)
    );
    always #2 clkA = ~clkA;   
    always #7 clkB = ~clkB; 
    task send_pulse();
        @(posedge clkA);
        signal_i <= 1;
        @(posedge clkA);
        signal_i <= 0;
        @(posedge clkA);          
        wait (busy_o == 0);       
    endtask
    initial begin
        rst_n    = 0;
        signal_i = 0;
        #20;
        rst_n = 1;
        repeat (3) @(posedge clkA);
        //Prueba 1
        send_pulse();
        repeat (5) @(posedge clkB);
        //Prueba 2
        send_pulse();
        repeat (5) @(posedge clkB);
        //Prueba 3
        send_pulse();
        repeat (5) @(posedge clkB);
        $finish;
    end
endmodule