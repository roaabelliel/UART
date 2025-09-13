module UART_RX #(
    parameter FRAME_WIDTH = 8,
    parameter BITS_WIDTH = FRAME_WIDTH + 2
)(
    input                        clk,
    input                        rst,
    input                        rx_en,
    input                        rx,
    output                       done,
    output                       busy,
    output                       err,
    output [FRAME_WIDTH - 1 : 0] data
);
    wire start_edge;
    wire stop_bit;
    wire half_bit_period;
    wire bit_period;
    wire load_baud;
    wire baud_en;
    wire cnt_busy;
    wire reg_en;
    wire frame_dn;

    rx_edge_detector start_bit_detector(.en(rx_en), .start_edge(start_edge), .stop_bit(stop_bit), .rx(rx), .clk(clk), .rst(rst));
    rx_baud_counter bit_timer(.cnt_en(baud_en), .cnt_load(load_baud), .cnt_done(bit_period), .half_cnt(half_bit_period), .cnt_busy(cnt_busy), .clk(clk), .rst(rst));
    rx_fsm rx_controller(.reg_en(reg_en), .err(err) , .busy(busy), .done(done), .frame_dn(frame_dn), .load_baud(load_baud), .baud_en(baud_en), .bit_period(bit_period), .half_bit_period(half_bit_period), .stop_bit(stop_bit), .start_edge(start_edge), .clk(clk), .rst(rst));
    rx_shift_register rx_SIPO_reg(.data(data), .rx(rx), .reg_en(reg_en), .clk(clk), .rst(rst));


endmodule
