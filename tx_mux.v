module tx_mux #(
    parameter SELECTOR_WIDTH = 4,
    parameter FRAME_WIDTH = 8,
    parameter BITS_WIDTH = FRAME_WIDTH + 2,
    parameter IDLE = 1'b1
)(
    input                          en,
    input [BITS_WIDTH - 1 : 0]     frame,
    input [SELECTOR_WIDTH - 1 : 0] bit_selector,
    output reg [0:0]               tx,
    output reg                     busy,
    output reg                     done
);

    integer i;
    always @* begin
        done <= 0;
        busy <= 0;
        if(en) begin
        busy <= 1;
            if(bit_selector == BITS_WIDTH - 1) begin
                tx <= frame[bit_selector];
                done <= 1;
                busy <= 0;
            end
            else if(bit_selector > BITS_WIDTH - 1)
                tx <= IDLE;
            else begin
                tx <= frame[bit_selector];
            end
        end
        else begin
            tx <= IDLE;
        end
    end

endmodule