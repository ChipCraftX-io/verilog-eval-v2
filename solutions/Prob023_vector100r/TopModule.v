module TopModule(
    input [99:0] in,
    output [99:0] out
);

    // Declare loop variable at module scope
    genvar i;
    
    // Generate block to reverse wire ordering
    generate
        for (i = 0; i < 100; i = i + 1) begin : reverse_bits
            assign out[i] = in[99 - i];
        end
    endgenerate

endmodule
