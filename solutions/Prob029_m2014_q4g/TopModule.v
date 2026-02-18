module TopModule (
    input  wire in1,
    input  wire in2,
    input  wire in3,
    output wire out
);

    // Internal signal for XNOR output
    wire xnor_out;
    
    // Two-input XNOR gate (in1, in2)
    assign xnor_out = in1 ~^ in2;  // XNOR: outputs 1 when inputs are equal
    
    // Two-input XOR gate (xnor_out, in3)
    assign out = xnor_out ^ in3;

endmodule
