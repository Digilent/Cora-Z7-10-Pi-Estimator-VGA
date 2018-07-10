`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent
// Engineer: Arvin Tang
//////////////////////////////////////////////////////////////////////////////////

module vga_comparator (
   output wire       lt,
   input  wire [9:0] a,
   input  wire [9:0] b
);

   assign lt = a < b;
endmodule

module vga_comparator_testbench ();
   wire       HS, VS;
   reg  [9:0] a_h, a_v;

   vga_comparator comp_h (.lt(HS), .a(a_h), .b(10'd96));
   vga_comparator comp_v (.lt(VS), .a(a_v), .b(10'd2));

   integer i, j;
   initial begin
      for (j = 0; j < 4; j = j + 1) begin
         a_v = j;
         for (i = 0; i < 100; i = i + 1) begin
            a_h = i; #10;
         end

         for (i = 790; i < 800; i = i + 1) begin
            a_h = i; #10;
         end
      end

      for (j = 500; j < 525; j = j + 1) begin
         a_v = j; #10;
      end
   end
endmodule
