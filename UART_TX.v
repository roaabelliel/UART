module UART_TX #(
    parameter SELECTOR_WIDTH = 4,
    parameter FRAME_WIDTH = 8,
    parameter BITS_WIDTH = FRAME_WIDTH + 2,
    parameter IDLE = 1'b1
)(
    input clk,
    input rst,
    input tx_en,
    input [FRAME_WIDTH - 1 : 0] data,
    output done,
    output busy,
    output tx
);
    wire [BITS_WIDTH - 1 : 0]     frame; 
    wire                          load; 
    wire                          cnt_done;
    wire [SELECTOR_WIDTH - 1 : 0] bit_selector;

    //instantiation of all internal modules
    tx_register frame_reg (.data_in(data), .data_out(frame), .load(tx_en), .clk(clk), .rst(rst));
    tx_bit_selector bit_select (.cnt_done(cnt_done), .bit_selector(bit_selector), .clk(clk), .rst(rst));
    tx_baud_counter timer (.cnt_en(tx_en), .cnt_done(cnt_done), .clk(clk), .rst(rst));
    tx_mux tx_generator (.frame(frame), .bit_selector(bit_selector), .tx(tx), .busy(busy), .done(done), .en(tx_en));


endmodule
