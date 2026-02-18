module TopModule (
    input [5:0] y,
    input w,
    output Y2,
    output Y4
);

    // One-hot state encoding:
    // A = y[0] = 000001
    // B = y[1] = 000010
    // C = y[2] = 000100
    // D = y[3] = 001000
    // E = y[4] = 010000
    // F = y[5] = 100000
    
    // Y2 = next state signal for y[1] (state B)
    // Transitions TO state B:
    //   A = A - 10 = 0 - 1> B: y[0] & ~w
    assign Y2 = y[0] & ~w;
    
    // Y4 = next state signal for y[3] (state D)
    // Transitions TO state D:
    //   B = B - 11 = 1 - 1> D: y[1] & w
    //   C = C - 11 = 1 - 1> D: y[2] & w
    //   E = E - 11 = 1 - 1> D: y[4] & w
    //   F = F - 11 = 1 - 1> D: y[5] & w
    assign Y4 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule
