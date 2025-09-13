module rx_baud_counter #(
    parameter BIT_COUNT = 10416
)(  input cnt_en,
    input cnt_load,
    input clk,
    input rst,
    output reg cnt_done,
    output reg half_cnt,
    output reg cnt_busy // flag for tb
);
    reg [13 : 0] baud_timer;

    wire start_edge;
    wire stop_bit;
    wire reg_en;
    wire err;
    wire busy;
    wire done;
    wire frame_dn;

    //instantiation of fsm
    //rx_fsm rx_controller(.load_baud(cnt_load), .baud_en(cnt_en), .bit_period(cnt_done), .half_bit_period(half_cnt), .reg_en(reg_en), .err(err) ,.busy(busy), .done(done), .frame_dn(frame_dn),  .stop_bit(stop_bit), .start_edge(start_edge), .clk(clk), .rst(rst));


    always @(posedge clk) begin
    //pre_declaration with default values to prevent unintended latches
        baud_timer <= 0;
        cnt_done <= 0;
        cnt_busy <= 0;
        half_cnt <= 0;
    if (rst) begin
        baud_timer <= 0;
        cnt_done <= 0;
        cnt_busy <= 0;
        half_cnt <= 0;
    end
    else begin
        if (cnt_load) begin
            baud_timer <= BIT_COUNT - 1;
            if(cnt_en) begin 
                if(baud_timer == 0) begin
                    cnt_done <= 1;
                    cnt_busy <= 0;
                end
                else if (baud_timer == (BIT_COUNT / 2 )- 1) //if counter reaches 1/2 bit period = 5208
                    half_cnt <= 1;
                else begin
                    baud_timer <= baud_timer - 1;
                    cnt_done <= 0;
                    cnt_busy <= 1;
                end
            end
            else if(!cnt_en) begin
                baud_timer <= baud_timer;
                cnt_done <= 0;
                cnt_busy <= 0;
            end
        end
    end     
end

endmodule

