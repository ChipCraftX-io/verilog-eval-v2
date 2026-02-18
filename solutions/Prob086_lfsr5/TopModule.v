module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

    // Initialize to non-zero value for proper LFSR operation
    initial begin : blk_1
        q = 5'h1;
    end

    // 5-wire Galois LFSR with taps at positions 5 and 3
    // Position 5 (wire 4): MSB gets q[0] feedback
    // Position 3 (wire 2): XORed with q[0]
    // Other positions: just shift right
    
    always @(posedge clk) begin : blk_2
        if (reset) begin
            q <= 5'h1;  // Reset to non-zero seed
        end else begin
            // Galois LFSR: shift right with tap feedback
            q[4] <= q[0];           // Tap at position 5: LSB feeds to MSB
            q[3] <= q[4];           // No tap: just shift right
            q[2] <= q[3] ^ q[0];    // Tap at position 3: XOR with LSB
            q[1] <= q[2];           // No tap: just shift right
            q[0] <= q[1];           // No tap: just shift right
        end
    end

endmodule
