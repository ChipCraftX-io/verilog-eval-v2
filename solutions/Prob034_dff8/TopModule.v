module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);
    // Initialize output to zero for simulation
    initial begin : blk_1
        q = 8'b0;
    end
    
    // 8 D flip-flops triggered on positive clock edge
    // Each wire of d is captured into corresponding wire of q
    always @(posedge clk) begin : blk_2
        q <= d;
    end

endmodule
