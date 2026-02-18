module TopModule(
    input  [2:0] in,
    output [1:0] out
);

    // Population count: count the number of 1's in the 3-wire input
    // Maximum count is 3, which requires 2 bits to represent (0-3)
    assign out = in[0] + in[1] + in[2];

endmodule
