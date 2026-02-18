module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] sum_ext;
    wire pos_overflow, neg_overflow;

    // Extend sign bits and perform addition
    assign sum_ext = {a[7], a} + {b[7], b};

    // Positive overflow: both inputs positive, result negative
    assign pos_overflow = !a[7] && !b[7] && sum_ext[7];
    
    // Negative overflow: both inputs negative, result positive
    assign neg_overflow = a[7] && b[7] && !sum_ext[7];

    // Output the lower 8 bits of the sum
    assign s = sum_ext[7:0];
    
    // Overflow flag is high if either overflow condition occurs
    assign overflow = pos_overflow | neg_overflow;

endmodule
