module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);
    // Decade counter: counts 0-9 with period 10
    // Synchronous active-high reset
    
    initial begin : blk_1
        q = 4'd0;
    end
    
    always @(posedge clk) begin : blk_2
        if (reset) begin
            q <= 4'd0;
        end else if (q == 4'd9) begin
            // Wrap at 9, return to 0
            q <= 4'd0;
        end else begin
            // Increment counter
            q <= q + 4'd1;
        end
    end

endmodule
