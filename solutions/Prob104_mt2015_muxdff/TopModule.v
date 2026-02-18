module TopModule (
  input clk,
  input L,
  input r_in,
  input q_in,
  output reg Q
);

  // Internal wire for mux output
  wire mux_out;
  
  // 2:1 Multiplexer
  // When L=1: select r_in (load)
  // When L=0: select q_in (shift/compute)
  assign mux_out = L ? r_in : q_in;
  
  // D Flip-Flop
  // Register the mux output on positive clock edge
  always @(posedge clk) begin : blk_1
    Q <= mux_out;
  end
  
  // Initialize output
  initial begin : blk_2
    Q = 1'b0;
  end

endmodule
