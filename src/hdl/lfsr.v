`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent
// Engineer: Arvin Tang
//////////////////////////////////////////////////////////////////////////////////

module lfsr_32 (
   output reg  [31:0] q,
   input  wire [31:0] seed,
   input  wire        enable,
   input  wire        clk,
   input  wire        reset
);

   wire [31:0] nextRand;
   xnor xn0 (nextRand[0], q[31], q[21], q[1], q[0]);
   assign nextRand[31:1] = q[30:0];
   always @ (posedge clk) begin
      if (reset)       q <= seed;
      else if (enable) q <= nextRand;
   end
endmodule

module lfsr_18 (
   output reg  [17:0] q,
   input  wire [17:0] seed,
   input  wire        enable,
   input  wire        clk,
   input  wire        reset
);

   wire [17:0] nextRand;
   xnor xn0 (nextRand[0], q[17], q[10]);
   assign nextRand[17:1] = q[16:0];
   always @ (posedge clk) begin
      if (reset)       q <= seed;
      else if (enable) q <= nextRand;
   end
endmodule

module lfsr32_testbench ();
   wire [31:0] q;
   reg  [31:0] seed;
   reg         enable, clk, reset;

   lfsr32 dut (
      .q(q),
      .seed(seed),
      .enable(enable),
      .clk(clk),
      .reset(reset)
   );

   parameter CLK_PER = 10;
   initial begin
      clk <= 1;
      forever #(CLK_PER / 2) clk <= ~clk;
   end

   initial begin
      reset <= 1; seed <= 32'hAAAA_CCCC; @(posedge clk);
      reset <= 0; enable <= 1;           @(posedge clk);
      repeat(24)                         @(posedge clk);
                  enable <= 0;           @(posedge clk);
      repeat(3)                          @(posedge clk);
                  enable <= 1;           @(posedge clk);
      repeat(3)                          @(posedge clk);
      $stop;
   end
endmodule

module lfsr18_testbench ();
   wire [17:0] q;
   reg  [17:0] seed;
   reg         enable, clk, reset;

   lfsr18 dut (
      .q(q),
      .seed(seed),
      .enable(enable),
      .clk(clk),
      .reset(reset)
   );

   parameter CLK_PER = 10;
   initial begin
      clk <= 1;
      forever #(CLK_PER / 2) clk <= ~clk;
   end

   initial begin
      reset <= 1; seed <= 18'h0_AACC; @(posedge clk);
      reset <= 0; enable <= 1;        @(posedge clk);
      repeat(24)                      @(posedge clk);
                  enable <= 0;        @(posedge clk);
      repeat(3)                       @(posedge clk);
                  enable <= 1;        @(posedge clk);
      repeat(3)                       @(posedge clk);
      $stop;
   end
endmodule
