`timescale 1ns/10ps
module UART_tx_tb ();

    parameter FRAME_WIDTH = 8;

    reg clk;
    reg rst;
    reg tx_en;
    reg [FRAME_WIDTH - 1 : 0] data;
    wire done;
    wire busy;
    wire tx;

    UART_TX tx_dut (.busy(busy), .tx(tx), .done(done), .data(data), .tx_en(tx_en), .clk(clk), .rst(rst));

    task drive_data(
        input [FRAME_WIDTH - 1 : 0] data_in
    );
        begin
            data = data_in;
        end
    endtask

    initial begin
        forever
        #5 clk = ~clk;
    end   

    initial
    begin
        clk = 0;
        tx_en = 0;
        rst = 1;
        #20
        tx_en = 1;
        rst = 0;
        drive_data( 8'b1110_1100);
        #1042000; //wait till done = 1

        tx_en = 0;
        rst = 1;
        #20
        tx_en = 1;
        rst = 0;
        drive_data( 8'b0110_1101);
        #1042000; //wait till done = 1

        $stop;
    end

endmodule