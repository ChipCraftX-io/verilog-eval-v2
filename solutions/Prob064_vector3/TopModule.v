module TopModule (
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    // Concatenate all inputs with two 1 bits in LSB positions
    // Total: 6*5 + 2 = 32 bits
    wire [31:0] concatenated;
    
    assign concatenated = {a, b, c, d, e, f, 2'b11};
    
    // Split into four 8-wire output vectors
    // w gets MSBs [31:24]
    // x gets [23:16]
    // y gets [15:8]
    // z gets LSBs [7:0]
    assign w = concatenated[31:24];
    assign x = concatenated[23:16];
    assign y = concatenated[15:8];
    assign z = concatenated[7:0];

endmodule
