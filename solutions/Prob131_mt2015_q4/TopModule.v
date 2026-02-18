module TopModule (
    input wire x,
    input wire y,
    output wire z
);
    // Internal signals
    wire a1_out, a2_out;
    wire b1_out, b2_out;
    wire or_out, and_out;
    
    // Instantiate two A submodules
    ModuleA inst_a1 (
        .x(x),
        .y(y),
        .z(a1_out)
    );
    
    ModuleA inst_a2 (
        .x(x),
        .y(y),
        .z(a2_out)
    );
    
    // Instantiate two B submodules
    ModuleB inst_b1 (
        .x(x),
        .y(y),
        .z(b1_out)
    );
    
    ModuleB inst_b2 (
        .x(x),
        .y(y),
        .z(b2_out)
    );
    
    // OR gate combining A1 and B1 outputs
    assign or_out = a1_out | b1_out;
    
    // AND gate combining A2 and B2 outputs
    assign and_out = a2_out & b2_out;
    
    // XOR gate combining OR and AND outputs to produce final output
    assign z = or_out ^ and_out;
    
endmodule
