module TopModule (
    input              clk,
    input              areset,
    input              load,
    input              ena,
    input       [3:0]  data,
    output reg  [3:0]  q
);

    // Initialize output to zero for proper simulation behavior
    initial begin : blk_1
        q = 4'b0;
    end

    // 4-wire shift register with asynchronous reset, synchronous load, and shift enable
    // Priority: areset > load > ena > hold
    always @(posedge clk or posedge areset) begin : blk_2
        if (areset) begin
            // Asynchronous reset: clear register to zero
            q <= 4'b0;
        end else if (load) begin
            // Synchronous load: load has priority over ena
            q <= data;
        end else if (ena) begin
            // Synchronous shift right: MSB becomes 0, LSB is shifted out
            q <= {1'b0, q[3:1]};
        end
        // else: hold current value (no change)
    end

endmodule
