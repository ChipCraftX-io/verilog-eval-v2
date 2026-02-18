module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);
    // Initialize output to zero for simulation
    initial begin : blk_1
        q = 4'b0000;
    end

    // 4-wire counter with synchronous reset
    always @(posedge clk) begin : blk_2
        if (reset)
            q <= 4'b0000;  // Reset to 0
        else
            q <= q + 4'b0001;  // Increment (wraps naturally at 15->0)
    end

endmodule
