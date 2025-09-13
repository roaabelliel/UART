module tx_baud_counter #(
    parameter BIT_COUNT = 10416, //bit period =  100MHz / 9600 = 10416.67 = 10416 (rounded down)
    parameter FRAME_WIDTH = 8,
    parameter BITS_WIDTH = FRAME_WIDTH + 2
)(

    input cnt_en,
    input clk,
    input rst,
    output reg cnt_done
);
    reg [13 : 0] bit_timer;

    always @(posedge clk) begin
        if (rst) begin
            bit_timer <= 0;
            cnt_done <= 0;
        end
        else  begin
            if(cnt_en) begin
                if(bit_timer == (BIT_COUNT - 1)) begin
                    cnt_done <= 1;
                    bit_timer <= 0;    
                end
                else if(bit_timer < (BIT_COUNT - 1)) begin
                    bit_timer <= bit_timer + 1;
                    cnt_done <= 0;
                end
            end
            else begin
                bit_timer <= 0;
                cnt_done <= 0;
            end
        end
    end


endmodule