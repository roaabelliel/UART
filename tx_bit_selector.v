module tx_bit_selector #(
    parameter SELECTOR_WIDTH = 4,
    parameter FRAME_WIDTH = 8,
    parameter BITS_WIDTH = FRAME_WIDTH + 2
)(
    input                                clk,
    input                                rst,
    input                                cnt_done,
    output reg [SELECTOR_WIDTH - 1 : 0]  bit_selector
);
    
    always @(posedge clk) begin
        if(rst) begin
            bit_selector <= 0;
        end
        else begin
             if(cnt_done) begin
                if(bit_selector < BITS_WIDTH) begin
                    bit_selector <= bit_selector + 1;
                end
                else begin
                    bit_selector <= 0;
                end
            end
        end
    end

endmodule