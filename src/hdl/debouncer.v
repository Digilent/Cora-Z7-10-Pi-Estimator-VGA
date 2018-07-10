`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent
// Engineer: Arthur Brown
//////////////////////////////////////////////////////////////////////////////////


module debouncer #(
    parameter DATA_WIDTH = 1,
    parameter NOISE_PERIOD = 256,
    parameter NOISE_PERIOD_CLOG2 = 8
) (
    input wire clk,
    input wire [DATA_WIDTH-1:0] din,
    output reg [DATA_WIDTH-1:0] dout = 0
);
    genvar i;
    generate for (i=0; i<DATA_WIDTH; i=i+1) begin : PER_BIT
        reg [NOISE_PERIOD_CLOG2-1:0] counter = 0;
        always@(posedge clk)
            if (din[i] == dout[i])
                counter <= 'b0;
            else if (counter + 1 >= NOISE_PERIOD) begin
                counter <= 'b0;
                dout[i] <= din[i];
            end else
                counter <= counter + 1;
    end endgenerate
endmodule
