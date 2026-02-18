module TopModule (
    input  clk,
    input  x,
    output z
);
    // Flip-flop outputs
    reg ff_xor_out;
    reg ff_and_out;
    reg ff_or_out;
    
    // Gate outputs (D inputs to flip-flops)
    wire xor_gate_out;
    wire and_gate_out;
    wire or_gate_out;
    
    // Initialize flip-flops to zero
    initial begin : blk_1
        ff_xor_out = 1'b0;
        ff_and_out = 1'b0;
        ff_or_out  = 1'b0;
    end
    
    // XOR gate: x XOR ff_xor_out
    assign xor_gate_out = x ^ ff_xor_out;
    
    // AND gate: x AND (NOT ff_and_out)
    assign and_gate_out = x & (~ff_and_out);
    
    // OR gate: x OR (NOT ff_or_out)
    assign or_gate_out = x | (~ff_or_out);
    
    // D flip-flops (positive edge triggered, reset to 0)
    always @(posedge clk) begin : blk_2
        ff_xor_out <= xor_gate_out;
        ff_and_out <= and_gate_out;
        ff_or_out  <= or_gate_out;
    end
    
    // 3-input NOR gate: output z
    assign z = ~(ff_xor_out | ff_and_out | ff_or_out);

endmodule
