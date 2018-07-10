`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent
// Engineer: Arvin Tang
//////////////////////////////////////////////////////////////////////////////////

module bus_mux_2_1 #(parameter WIDTH = 64) (
   output wire [WIDTH - 1 : 0] out,
   input  wire [WIDTH - 1 : 0] in0,
   input  wire [WIDTH - 1 : 0] in1,
   input  wire                 sel
);

   genvar i;
   generate
      for (i = 0; i < WIDTH; i = i + 1) begin : muxes
         mux_2_1 m (.out(out[i]), .in0(in0[i]), .in1(in1[i]), .sel(sel));
      end
   endgenerate
endmodule

module mux_2_1 (
   output wire out,
   input  wire in0,
   input  wire in1,
   input  wire sel
);

   wire seln;
   not n (seln, sel);

   wire out0, out1;
   and a0 (out0, in0, seln);
   and a1 (out1, in1, sel);

   or o (out, out0, out1);
endmodule

module mux_4_1 (
   output wire       out,
   input  wire [3:0] in,
   input  wire [1:0] sel
);

   wire [1:0] seln;
   not n0 (seln[0], sel[0]);
   not n1 (seln[1], sel[1]);

   wire out0, out1, out2, out3;
   and a0 (out0, in[0], seln[1], seln[0]);
   and a1 (out1, in[1], seln[1], sel[0]);
   and a2 (out2, in[2], sel[1],  seln[0]);
   and a3 (out3, in[3], sel[1],  sel[0]);

   or o (out, out0, out1, out2, out3);
endmodule
