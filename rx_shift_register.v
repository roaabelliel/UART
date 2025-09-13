module rx_shift_register #(
    parameter FRAME_WIDTH = 8
)(
    input clk,
    input rst,
    input reg_en,
    input rx,
    output reg [FRAME_WIDTH - 1 : 0] data
);
    wire start_edge;
    wire stop_bit;
    wire half_bit_period;
    wire bit_period;
    wire load_baud;
    wire baud_en;
    wire err;
    wire busy;
    wire done;
    wire frame_dn;

    //instantiation of fsm
    rx_fsm rx_controller(.reg_en(reg_en),.err(err) ,.busy(busy), .done(done), .frame_dn(frame_dn), .load_baud(load_baud), .baud_en(baud_en), .bit_period(bit_period), .half_bit_period(half_bit_period), .stop_bit(stop_bit), .start_edge(start_edge), .clk(clk), .rst(rst));

    always @(posedge clk) begin
        if(rst)
            data <= {FRAME_WIDTH{1'b0}};
        else begin
            if(reg_en) //register frame using SIPO shift register (left shift)
                data <= {data[FRAME_WIDTH - 2 : 0] ,rx};
            else
                data <= data;
        end
    end
    
endmodule
