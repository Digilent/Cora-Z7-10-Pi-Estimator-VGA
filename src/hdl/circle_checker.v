`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent
// Engineer: Arvin Tang
//////////////////////////////////////////////////////////////////////////////////

module circle_checker (
   output reg        isInside,
   input  wire [9:0] xCoord,
   input  wire [9:0] yCoord
);

   parameter CIRCLE_RADIUS_SQUARED = 18'h3_8400;

   reg [18:0] xSquared, ySquared;
   reg [19:0] squaredSum;
   
   always @ (*) begin
      xSquared = xCoord * xCoord;
      ySquared = yCoord * yCoord;
      squaredSum = xSquared + ySquared;
      isInside = squaredSum <= CIRCLE_RADIUS_SQUARED;
   end
endmodule

module circle_checker_testbench ();
   wire       isInside;
   reg  [9:0] xCoord, yCoord;
   
   circle_checker dut (.isInside(isInside), .xCoord(xCoord), .yCoord(yCoord));
   
   initial begin
      xCoord <= 10'd0;   yCoord <= 10'd0;   #10;
      xCoord <= 10'd472;                    #10;
                         yCoord <= 10'd472; #10;
      xCoord <= 10'd333;                    #10;
                         yCoord <= 10'd333; #10;
      xCoord <= 10'd400;                    #10;
      $stop;
   end
endmodule
