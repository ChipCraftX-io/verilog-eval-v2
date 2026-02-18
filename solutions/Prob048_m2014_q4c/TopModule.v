module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);
    // Initialize output for clean simulation
    initial begin : blk_1
        q = 1'b0;
    end
    
    // D flip-flop with synchronous active-high reset
    always @(posedge clk) begin : blk_2
        if (r)
            q <= 1'b0;  // Reset has priority
        else
            q <= d;     // Capture input data
    end

endmodule
