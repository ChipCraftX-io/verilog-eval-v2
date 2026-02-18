module TopModule(
  input clk,
  input reset,
  output reg [9:0] q
);

  // Counter needs to count 0-999, requires 10 bits (2^10 = 1024 > 999)
  // Use $clog2(1000) = 10 bits
  
  // Initialize output to zero for correct simulation behavior
  initial begin : blk_1
    q = 10'd0;
  end
  
  // Synchronous counter with active-high reset
  always @(posedge clk) begin : blk_2
    if (reset) begin
      q <= 10'd0;
    end else begin
      // Count from 0 to 999, wrap to 0 at 1000
      if (q == 10'd999) begin
        q <= 10'd0;
      end else begin
        q <= q + 10'd1;
      end
    end
  end

endmodule
