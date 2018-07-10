`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent
// Engineer: Arvin Tang
//////////////////////////////////////////////////////////////////////////////////

module pi_estimator_vga (
   output wire       HS,
   output wire       VS,
   output wire [9:0] px_x,
   output wire [9:0] px_y,
   output wire       vidSel,
   input  wire       clk25,
   input  wire       reset
);

   wire [9:0] hCount, vCount;
   wire       tc_h, tc_v;

   assign px_x = hCount - 10'd144;
   assign px_y = vCount - 10'd35;

   wire horizCountReset, vertCountReset;
   assign horizCountReset = reset | tc_h;
   assign vertCountReset = reset | (tc_h & tc_v);
   vga_counter #(.TERMINAL_COUNT(799)) horizCount (
      .q(hCount),
      .tc(tc_h),
      .en(1'b1),
      .clk(clk25),
      .reset(horizCountReset)
   );
   vga_counter #(.TERMINAL_COUNT(524)) vertCount (
      .q(vCount),
      .tc(tc_v),
      .en(tc_h),
      .clk(clk25),
      .reset(vertCountReset)
   );

   wire HSn, VSn;
   vga_comparator horizComp (.lt(HSn), .a(hCount), .b(10'd96));
   vga_comparator vertComp (.lt(VSn), .a(vCount), .b(10'd2));
   assign HS = ~HSn;
   assign VS = ~VSn;

   wire ltHorizLow, ltHorizHigh;
   vga_comparator horizLowCheck (.lt(ltHorizLow), .a(hCount), .b(10'd144));
   vga_comparator horizHighCheck (.lt(ltHorizHigh), .a(hCount), .b(10'd784));

   wire ltVertLow, ltVertHigh;
   vga_comparator vertLowCheck (.lt(ltVertLow), .a(vCount), .b(10'd35));
   vga_comparator vertHighCheck (.lt(ltVertHigh), .a(vCount), .b(10'd515));

   assign vidSel = ~ltHorizLow & ltHorizHigh & ~ltVertLow & ltVertHigh;
endmodule

module pi_estimator_vga_testbench ();
   wire HS, VS, vidSel;
   reg  clk, reset;

   pi_estimator_vga dut (
      .HS(HS),
      .VS(VS),
      .vidSel(vidSel),
      .clk25(clk),
      .reset(reset)
   );

   parameter CLK_PER = 40;
   initial begin
      clk <= 1;
      forever #(CLK_PER / 2) clk <= ~clk;
   end

   initial begin
      reset <= 1; @(posedge clk);
      reset <= 0; @(posedge clk);
      repeat (1680400) @(posedge clk);
      $stop;
   end
endmodule
