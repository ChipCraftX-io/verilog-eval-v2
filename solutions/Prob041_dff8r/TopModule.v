module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    // Initialize output to zero for simulation
    initial begin : blk_1
        q = 8'b0;
    end

    // 8-wire D flip-flop with synchronous reset
    always @(posedge clk) begin : blk_2
        if (reset)
            q <= 8'b0;
        else
            q <= d;
    end

endmodule
