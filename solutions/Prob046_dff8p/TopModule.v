module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);
    // Initialize output to reset value for simulation
    initial begin : blk_1
        q = 8'h34;
    end
    
    // 8 D flip-flops with active high synchronous reset
    // Triggered on negative edge of clk
    // Reset value is 0x34 instead of 0x00
    always @(negedge clk) begin : blk_2
        if (reset)
            q <= 8'h34;  // Reset to 0x34
        else
            q <= d;      // Normal D flip-flop behavior
    end

endmodule
