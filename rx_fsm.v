module rx_fsm #(
    parameter FRAME_WIDTH = 8,
    //FSM states
    parameter START    = 3'b000,
    parameter IDLE     = 3'b001,
    parameter REG_DATA = 3'b010,
    parameter ERROR    = 3'b011,
    parameter DONE     = 3'b100
)(
    input clk,
    input rst,
    input start_edge,
    input stop_bit,
    input half_bit_period,
    input bit_period, 
    output reg_en,
    output load_baud,
    output baud_en,
    output err,
    output busy,
    output done,
    output reg frame_dn //flag for tb
);

reg [2 : 0] cs, ns;
reg [3 : 0] bit_counter; 
wire rx;
wire cnt_busy; 

    //instantiation of edge detector & baud_counter
    //rx_edge_detector start_bit_detector(.start_edge(start_edge), .stop_bit(stop_bit), .rx(rx), .clk(clk), .rst(rst));
    //rx_baud_counter bit_timer(.cnt_en(baud_en), .cnt_load(load_baud), .cnt_done(bit_period), .half_cnt(half_bit_period), .cnt_busy(cnt_busy), .clk(clk), .rst(rst));

  always @* begin
    case(cs)
        IDLE: ns = (start_edge) ? START : IDLE;
        START: ns = (half_bit_period) ? REG_DATA : START;
        
        REG_DATA:begin
            bit_counter = 0;
            frame_dn = 0;
            //checking if last bit is stop bit
            if(bit_counter ==  FRAME_WIDTH + 1) begin
                bit_counter = 0;
                frame_dn = 1;
                if(stop_bit)
                    ns = DONE;
                else
                    ns = ERROR;
            end
            else begin
            //bit counter to keep track of number of bits registered
                ns = REG_DATA;
                if (bit_period)
                    bit_counter = bit_counter + 1;
                else
                    bit_counter = bit_counter;
            end
        end
        ERROR: ns = IDLE;
        DONE: ns = IDLE;
    endcase
  end

  always @(posedge clk) begin
    if(rst) 
        cs <= IDLE;
    else
        cs <= ns;
    end

    assign load_baud = (cs == START);
    assign baud_en = (cs == START || cs == REG_DATA);
    assign cnt_busy = (cs == START || cs == REG_DATA);
    assign reg_en = (cs == REG_DATA && !stop_bit);
    assign busy = (cs == REG_DATA || cs == START);
    assign done = (cs == DONE);
    assign err = (cs == ERROR);


endmodule