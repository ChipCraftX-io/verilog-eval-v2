module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1: Next state reg for y[1] (state B)
    // State B is reached from:
    //   - State A (y[0]) when w=1
    assign Y1 = y[0] & w;

    // Y3: Next state reg for y[3] (state D)
    // State D is reached from:
    //   - State B (y[1]) when w=0
    //   - State C (y[2]) when w=0
    //   - State E (y[4]) when w=0
    //   - State F (y[5]) when w=0
    assign Y3 = (y[1] & ~w) | 
                (y[2] & ~w) | 
                (y[4] & ~w) | 
                (y[5] & ~w);

endmodule
