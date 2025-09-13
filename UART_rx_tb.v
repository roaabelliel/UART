module UART_rx_tb;
parameter CLK_FREQ   = 100_000_000;       // 100 MHz
parameter BAUD_RATE  = 9600;
parameter BIT_PERIOD = CLK_FREQ / BAUD_RATE; // = 10416 clock cycles
parameter BIT_TIME   = BIT_PERIOD * 10;   // in ns (10 ns per cycle at 100MHz)
parameter FRAME_WIDTH = 8;

reg clk;
    reg rst;
    reg rx_en;
    reg rx;
    wire [FRAME_WIDTH-1:0] data;
    wire done;
    wire busy;
    wire err;

    UART_RX  rx_dut (.data(data), .rx_en(rx_en), .rx(rx), .done(done), .busy(busy), .err(err), .clk(clk), .rst(rst));

    task drive_rx(
        input start,
        input [FRAME_WIDTH - 1 : 0] data_in,
        input stop
    );
        integer i;
        begin
            rx = start;
            #BIT_TIME;
            // driving rx (LSB first)
            for (i = 0; i < FRAME_WIDTH; i = i + 1) begin
                rx = data_in[i];
                #BIT_TIME;
            end
            rx = stop;
            #BIT_TIME;
        end
    endtask
    

    initial clk = 0;
    always #5 clk = ~clk;
    
    initial 
    begin
    rst = 1;
    rx_en = 0;
    #100;        // reset active
    rst = 0;
    rx_en = 1;

    // frame 1
    drive_rx(1'b0, 8'b0110_1100, 1'b1);
    # (BIT_TIME * (FRAME_WIDTH + 2) + 1000); // wait full frame

    $display("Time %0t: data=%b done=%b err=%b busy=%b", $time, data, done, err, busy);

    // frame 2
    drive_rx(1'b0, 8'b1010_1111, 1'b1);
    # (BIT_TIME * (FRAME_WIDTH + 2) + 1000);

    $display("Time %0t: data=%b done=%b err=%b busy=%b", $time, data, done, err, busy);

    /*drive_rx(1'b0, 8'b1010_1111, 1'b0);
    $display("At time = %0t, done = %b , error = %b, busy = %b,  data = %b", $time, done, err, busy, data);
    #10;
        drive_rx(1'b0, 8'b1010_1111, 1'b1);
        $display("At time = %0t, done = %b , error = %b, busy = %b,  data = %b", $time, done, err, busy, data);
        #10;*/

    $stop;
    end
    
endmodule