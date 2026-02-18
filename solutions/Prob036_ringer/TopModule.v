module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

    // Combinational reg to control ringer and motor
    // When ring is asserted:
    //   - If vibrate_mode is 1, activate motor
    //   - If vibrate_mode is 0, activate ringer
    // When ring is not asserted, both outputs are 0
    
    assign motor = ring & vibrate_mode;
    assign ringer = ring & ~vibrate_mode;

endmodule
