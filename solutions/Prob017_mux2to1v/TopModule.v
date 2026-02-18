module TopModule(
  input [99:0] a,
  input [99:0] b,
  input sel,
  output reg [99:0] out
);
  always @(*) begin : blk_1
    if (sel == 1'b0)
      out = a;
    else
      out = b;
  end
endmodule
