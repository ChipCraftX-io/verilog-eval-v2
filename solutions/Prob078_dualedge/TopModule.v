module TopModule (
    input  clk,
    input  d,
    output q
);

    // Internal signals
    reg q_pos;  // Positive edge triggered flip-flop output
    reg q_neg;  // Negative edge triggered flip-flop output
    
    // Initialize outputs to zero for correct simulation behavior
    initial begin : blk_1
        q_pos = 1'b0;
        q_neg = 1'b0;
    end
    
    // Positive edge triggered flip-flop
    // Captures data on rising edge of clk
    always @(posedge clk) begin : blk_2
        q_pos <= d;
    end
    
    // Negative edge triggered flip-flop
    // Captures data on falling edge of clk (posedge of ~clk)
    always @(negedge clk) begin : blk_3
        q_neg <= d;
    end
    
    // Multiplexer: select appropriate output based on clock level
    // When clk is high, use the value captured on the rising edge (q_pos)
    // When clk is low, use the value captured on the falling edge (q_neg)
    assign q = clk ? q_pos : q_neg;

endmodule
