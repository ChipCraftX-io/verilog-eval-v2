module TopModule (
    input wire in,
    input wire [3:0] state,
    output wire [3:0] next_state,
    output wire out
);

    // One-hot state encoding:
    // A = 4'b0001 (state[0])
    // B = 4'b0010 (state[1])
    // C = 4'b0100 (state[2])
    // D = 4'b1000 (state[3])

    // Next state reg derived by inspection of transition table
    // For each next_state bit, OR together all (current_state & condition) 
    // pairs that lead to that next state
    
    // next_state[0] = A: Reached from A(in=0) or C(in=0)
    assign next_state[0] = (state[0] & ~in) | (state[2] & ~in);
    
    // next_state[1] = B: Reached from A(in=1), B(in=1), or D(in=1)
    assign next_state[1] = (state[0] & in) | (state[1] & in) | (state[3] & in);
    
    // next_state[2] = C: Reached from B(in=0) or D(in=0)
    assign next_state[2] = (state[1] & ~in) | (state[3] & ~in);
    
    // next_state[3] = D: Reached from C(in=1)
    assign next_state[3] = (state[2] & in);

    // Output reg (Moore machine - output depends only on current state)
    // Output is 1 only in state D
    assign out = state[3];

endmodule
