module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // One-hot state encoding (for readability)
    wire s0, s1, s2, s3, s4, s5, s6, s7, s8, s9;
    assign {s9, s8, s7, s6, s5, s4, s3, s2, s1, s0} = state;

    // Next state reg - one-hot encoding
    // Each next_state[i] is the OR of all transitions leading to state i
    
    // next_state[0]: S0 - reached from any state on input=0, except S5→S8 and S6→S9
    assign next_state[0] = (~in & s0) |  // S0 = S0 - 10 = 0 - 1> S0
                           (~in & s1) |  // S1 = S1 - 10 = 0 - 1> S0
                           (~in & s2) |  // S2 = S2 - 10 = 0 - 1> S0
                           (~in & s3) |  // S3 = S3 - 10 = 0 - 1> S0
                           (~in & s4) |  // S4 = S4 - 10 = 0 - 1> S0
                           (~in & s7) |  // S7 = S7 - 10 = 0 - 1> S0
                           (~in & s8) |  // S8 = S8 - 10 = 0 - 1> S0
                           (~in & s9);   // S9 = S9 - 10 = 0 - 1> S0
    
    // next_state[1]: S1 - reached from S0, S8, S9 on input=1
    assign next_state[1] = (in & s0) |   // S0 = S0 - 11 = 1 - 1> S1
                           (in & s8) |   // S8 = S8 - 11 = 1 - 1> S1
                           (in & s9);    // S9 = S9 - 11 = 1 - 1> S1
    
    // next_state[2]: S2 - reached from S1 on input=1
    assign next_state[2] = (in & s1);    // S1 = S1 - 11 = 1 - 1> S2
    
    // next_state[3]: S3 - reached from S2 on input=1
    assign next_state[3] = (in & s2);    // S2 = S2 - 11 = 1 - 1> S3
    
    // next_state[4]: S4 - reached from S3 on input=1
    assign next_state[4] = (in & s3);    // S3 = S3 - 11 = 1 - 1> S4
    
    // next_state[5]: S5 - reached from S4 on input=1
    assign next_state[5] = (in & s4);    // S4 = S4 - 11 = 1 - 1> S5
    
    // next_state[6]: S6 - reached from S5 on input=1
    assign next_state[6] = (in & s5);    // S5 = S5 - 11 = 1 - 1> S6
    
    // next_state[7]: S7 - reached from S6 on input=1, or S7 on input=1 (self-loop)
    assign next_state[7] = (in & s6) |   // S6 = S6 - 11 = 1 - 1> S7
                           (in & s7);    // S7 = S7 - 11 = 1 - 1> S7
    
    // next_state[8]: S8 - reached from S5 on input=0
    assign next_state[8] = (~in & s5);   // S5 = S5 - 10 = 0 - 1> S8
    
    // next_state[9]: S9 - reached from S6 on input=0
    assign next_state[9] = (~in & s6);   // S6 = S6 - 10 = 0 - 1> S9

    // Output reg - Moore outputs (depend only on current state)
    // S7: (0, 1), S8: (1, 0), S9: (1, 1), all others: (0, 0)
    // When multiple states active, OR the outputs together
    assign out1 = s8 | s9;
    assign out2 = s7 | s9;

endmodule
