module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Initialize to non-zero value
    initial begin : blk_1
        q = 32'h1;
    end

    // 32-wire Galois LFSR with taps at positions 32, 22, 2, 1
    // In 0-indexed: bits 31, 21, 1, 0
    // Shifts right, tapped positions XOR with q[0]
    
    always @(posedge clk) begin : blk_2
        if (reset) begin
            q <= 32'h1;  // Reset to non-zero seed
        end else begin
            // Galois LFSR: shift right with tap feedback
            // Bit 31 (tap at position 32): gets q[0] feedback
            q[31] <= q[0];
            
            // Bits 30-22: shift right (no taps)
            q[30:22] <= q[31:23];
            
            // Bit 21 (tap at position 22): shift right XOR q[0]
            q[21] <= q[22] ^ q[0];
            
            // Bits 20-2: shift right (no taps)
            q[20:2] <= q[21:3];
            
            // Bit 1 (tap at position 2): shift right XOR q[0]
            q[1] <= q[2] ^ q[0];
            
            // Bit 0 (tap at position 1): shift right XOR q[0]
            q[0] <= q[1] ^ q[0];
        end
    end

endmodule
