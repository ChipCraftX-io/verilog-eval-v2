module TopModule(
    input wire x,
    input wire y,
    output wire z
);

    // XNOR gate: output is 1 when inputs are equal
    // Truth table:
    // x=0, y=0 -> z=1
    // x=0, y=1 -> z=0
    // x=1, y=0 -> z=0
    // x=1, y=1 -> z=1
    
    assign z = ~(x ^ y);

endmodule
