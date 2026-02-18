module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // 4-input AND gate: all bits must be 1 for output to be 1
    assign out_and = in[3] & in[2] & in[1] & in[0];
    
    // 4-input OR gate: any wire being 1 makes output 1
    assign out_or  = in[3] | in[2] | in[1] | in[0];
    
    // 4-input XOR gate: output is 1 if odd number of inputs are 1
    assign out_xor = in[3] ^ in[2] ^ in[1] ^ in[0];

endmodule
