module TopModule(
    input  clk,
    input  in,
    output out
);

    // Internal signal for the XOR output (D input to flip-flop)
    wire d_input;
    
    // Register for the D flip-flop output
    reg q;
    
    // Initialize output to 0 for proper simulation behavior
    initial begin : blk_1
        q = 1'b0;
    end
    
    // XOR gate: combines input 'in' with feedback from flip-flop output
    assign d_input = in ^ q;
    
    // D flip-flop: positive edge triggered, no reset
    always @(posedge clk) begin : blk_2
        q <= d_input;
    end
    
    // Connect flip-flop output to module output
    assign out = q;

endmodule
