module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);
    // mux_in[0] corresponds to ab=00
    // From K-map column ab=00: output is 1 when cd=01, 11, or 10
    // Simplified: c OR d
    assign mux_in[0] = c | d;
    
    // mux_in[1] corresponds to ab=01
    // From K-map column ab=01: output is always 0
    assign mux_in[1] = 1'b0;
    
    // mux_in[2] corresponds to ab=10
    // From K-map column ab=10: output is 1 when cd=00, 11, or 10
    // Simplified: NOT d
    assign mux_in[2] = ~d;
    
    // mux_in[3] corresponds to ab=11
    // From K-map column ab=11: output is 1 only when cd=11
    // Simplified: c AND d
    assign mux_in[3] = c & d;

endmodule
