module TopModule(
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);
    // Initialize output to zero for simulation
    initial begin : blk_1
        q = 8'b0;
    end
    
    // 8 D flip-flops with active high asynchronous reset
    always @(posedge clk or posedge areset) begin : blk_2
        if (areset)
            q <= 8'b0;      // Asynchronous reset to 0
        else
            q <= d;         // Capture input on positive clock edge
    end

endmodule
