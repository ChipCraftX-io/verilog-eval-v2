module TopModule (
    input wire d,
    input wire done_counting,
    input wire ack,
    input wire [9:0] state,
    output wire B3_next,
    output wire S_next,
    output wire S1_next,
    output wire Count_next,
    output wire Wait_next,
    output wire done,
    output wire counting,
    output wire shift_ena
);

    // One-hot state encoding (provided in spec)
    // state[0] = S
    // state[1] = S1
    // state[2] = S11
    // state[3] = S110
    // state[4] = B0
    // state[5] = B1
    // state[6] = B2
    // state[7] = B3
    // state[8] = Count
    // state[9] = Wait

    // Extract individual state bits for readability
    wire S, S1, S11, S110, B0, B1, B2, B3, Count, Wait;
    assign S     = state[0];
    assign S1    = state[1];
    assign S11   = state[2];
    assign S110  = state[3];
    assign B0    = state[4];
    assign B1    = state[5];
    assign B2    = state[6];
    assign B3    = state[7];
    assign Count = state[8];
    assign Wait  = state[9];

    // ========================================================================
    // NEXT-STATE LOGIC (ONE-HOT)
    // For each state, determine all transitions that lead TO that state
    // ========================================================================

    // S_next: transitions TO state S
    // - From S when d=0
    // - From S1 when d=0
    // - From S110 when d=0
    // - From Wait when ack=1
    assign S_next = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);

    // S1_next: transitions TO state S1
    // - From S when d=1
    assign S1_next = (S & d);

    // S11_next: transitions TO state S11
    // - From S1 when d=1
    // - From S11 when d=1 (self-loop for overlapping sequence)
    wire S11_next;
    assign S11_next = (S1 & d) | (S11 & d);

    // S110_next: transitions TO state S110
    // - From S11 when d=0
    wire S110_next;
    assign S110_next = (S11 & ~d);

    // B0_next: transitions TO state B0
    // - From S110 when d=1
    wire B0_next;
    assign B0_next = (S110 & d);

    // B1_next: transitions TO state B1
    // - From B0 (always)
    wire B1_next;
    assign B1_next = B0;

    // B2_next: transitions TO state B2
    // - From B1 (always)
    wire B2_next;
    assign B2_next = B1;

    // B3_next: transitions TO state B3
    // - From B2 (always)
    assign B3_next = B2;

    // Count_next: transitions TO state Count
    // - From B3 (always)
    // - From Count when done_counting=0 (self-loop)
    assign Count_next = B3 | (Count & ~done_counting);

    // Wait_next: transitions TO state Wait
    // - From Count when done_counting=1
    // - From Wait when ack=0 (self-loop)
    assign Wait_next = (Count & done_counting) | (Wait & ~ack);

    // ========================================================================
    // OUTPUT LOGIC (MOORE - derived from current state only)
    // ========================================================================

    // shift_ena: asserted in states B0, B1, B2, B3
    assign shift_ena = B0 | B1 | B2 | B3;

    // counting: asserted in state Count
    assign counting = Count;

    // done: asserted in state Wait
    assign done = Wait;

endmodule
