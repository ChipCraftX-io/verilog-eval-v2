module TopModule(
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: each wire checks if both current and left neighbor are 1
    // out_both[i] = in[i] & in[i+1]
    assign out_both[2:0] = in[2:0] & in[3:1];
    assign out_both[3] = 1'bx;  // Don't care - no left neighbor for in[3]
    
    // out_any: each wire checks if either current or right neighbor is 1
    // out_any[i] = in[i] | in[i-1]
    assign out_any[3:1] = in[3:1] | in[2:0];
    assign out_any[0] = 1'bx;   // Don't care - no right neighbor for in[0]
    
    // out_different: each wire checks if current differs from left neighbor (wrapping)
    // out_different[i] = in[i] ^ in[i+1], with wrapping: in[3]'s left is in[0]
    assign out_different = in ^ {in[0], in[3:1]};

endmodule
