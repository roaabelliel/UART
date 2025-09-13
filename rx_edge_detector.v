module rx_edge_detector #(     
//is this module even necessary? couldn't it be replaced with FSM logic 
    parameter IDLE   = 1'b1,
    parameter START  = 1'b0
)(
    input clk,
    input rst,
    input en,
    input rx,
    output reg start_edge,
    output reg stop_bit
);
    reg ns, cs;

    always @* begin
        case(cs)
            IDLE:  ns = (rx) ? IDLE : START;

            START: ns = (rx) ? IDLE : START;

        endcase
    end

    always @(posedge clk) begin
            if(rst)
                cs <= IDLE;
            else
                cs <= ns;
    end

    always @*
    begin
        if(en) begin
        start_edge = (cs == IDLE && rx == 0);
        stop_bit = (rx);
        end
    end
endmodule