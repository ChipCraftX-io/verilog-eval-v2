module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // 100-input AND gate
    // Output is 1 only if ALL inputs are 1
    assign out_and = &in;

    // 100-input OR gate
    // Output is 1 if ANY input is 1
    assign out_or = |in;

    // 100-input XOR gate
    // Output is 1 if ODD number of inputs are 1
    assign out_xor = ^in;

endmodule
