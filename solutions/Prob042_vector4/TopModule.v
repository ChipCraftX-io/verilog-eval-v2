module TopModule (
    input  [7:0]  in,
    output [31:0] out
);
    // Sign-extend 8-wire input to 32 bits
    // Replicate sign bit (in[7]) 24 times and concatenate with original 8 bits
    assign out = {{24{in[7]}}, in};

endmodule
