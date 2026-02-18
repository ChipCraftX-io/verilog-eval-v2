module TopModule (
  input  wire clk,
  input  wire ar,
  input  wire d,
  output reg  q
);

  // D flip-flop with asynchronous reset
  // Reset is active high (ar=1 forces q=0)
  always @(posedge clk or posedge ar) begin : blk_1
    if (ar)
      q <= 1'b0;  // Asynchronous reset to 0
    else
      q <= d;     // Capture input on rising clock edge
  end

  // Initialize output for simulation
  initial begin : blk_2
    q = 1'b0;
  end

endmodule
