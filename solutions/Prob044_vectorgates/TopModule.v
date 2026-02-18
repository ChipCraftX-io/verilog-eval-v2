module TopModule(
    input wire [2:0] a,
    input wire [2:0] b,
    output wire [2:0] out_or_bitwise,
    output wire out_or_logical,
    output wire [5:0] out_not
);

    // Bitwise OR: Each wire of a OR'd with corresponding wire of b
    assign out_or_bitwise = a | b;
    
    // Logical OR: True if either vector is non-zero
    // This is equivalent to: (a != 0) || (b != 0)
    // In Verilog, |a reduces a to single bit (OR of all bits)
    assign out_or_logical = |a | |b;
    
    // Bitwise NOT of both vectors, concatenated
    // Upper half [5:3] = ~b, Lower half [2:0] = ~a
    assign out_not = {~b, ~a};

endmodule
