module TopModule(
    input clk,
    input d,
    output reg q
);

    // Initialize output to zero for correct simulation behavior
    initial begin : blk_1
        q = 1'b0;
    end

    // D flip-flop: capture input d on positive clock edge
    always @(posedge clk) begin : blk_2
        q <= d;
    end

endmodule
