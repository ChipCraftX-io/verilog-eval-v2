module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    // Register to store previous cycle's input
    reg [7:0] in_prev;
    
    // Initialize registers to zero
    initial begin : blk_1
        in_prev = 8'b0;
        anyedge = 8'b0;
    end
    
    always @(posedge clk) begin : blk_2
        // Store current input for next cycle comparison
        in_prev <= in;
        
        // Detect edges: XOR current with previous
        // XOR produces 1 when bits differ (edge detected)
        anyedge <= in ^ in_prev;
    end

endmodule
