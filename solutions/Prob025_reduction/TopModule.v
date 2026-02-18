module TopModule(
    input [7:0] in,
    output parity
);
    // Even parity generation using XOR reduction
    // XOR all 8 bits together
    // Result is 1 if odd number of 1-bits (even parity bit)
    assign parity = ^in;

endmodule
