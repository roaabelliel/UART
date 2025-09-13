module tx_register #(
    parameter FRAME_WIDTH = 8,
    parameter BITS_WIDTH = FRAME_WIDTH + 2
)(
    input  wire [FRAME_WIDTH - 1 : 0] data_in,
    input  wire                       load,
    input  wire                       clk, 
    input  wire                       rst,
    output reg  [BITS_WIDTH - 1 : 0] data_out
);
    
    always @(posedge clk) begin
        if(rst)
            data_out <= {FRAME_WIDTH{1'b0}};
        else
            if(load)
                data_out <= {1'b0, data_in, 1'b1};
            else
                data_out <= data_out;
    end


endmodule