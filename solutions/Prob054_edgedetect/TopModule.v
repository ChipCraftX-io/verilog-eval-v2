module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    // Store previous cycle's input value
    reg [7:0] in_prev;
    
    // Initialize registers
    initial begin : blk_1
        in_prev = 8'b0;
        pedge = 8'b0;
    end
    
    // Sequential reg: capture previous input and detect edges
    always @(posedge clk) begin : blk_2
        // Store current input for next cycle comparison
        in_prev <= in;
        
        // Detect positive edge on each wire independently
        // Edge occurs when current wire is 1 AND previous wire was 0
        pedge <= in & ~in_prev;
    end

endmodule
