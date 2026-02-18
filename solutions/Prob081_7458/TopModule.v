module TopModule (
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p1e,
    input  p1f,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

    // Intermediate wires for the four AND gate outputs
    wire and1_out;  // 3-input AND: p1a & p1b & p1c
    wire and2_out;  // 3-input AND: p1d & p1e & p1f
    wire and3_out;  // 2-input AND: p2a & p2b
    wire and4_out;  // 2-input AND: p2c & p2d

    // Four AND gates
    assign and1_out = p1a & p1b & p1c;
    assign and2_out = p1d & p1e & p1f;
    assign and3_out = p2a & p2b;
    assign and4_out = p2c & p2d;

    // Two OR gates combining the AND gate outputs
    assign p1y = and1_out | and2_out;
    assign p2y = and3_out | and4_out;

endmodule
