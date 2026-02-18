module TopModule(
    input wire clk,
    input wire reset,
    input wire x,
    output wire z
);

    // State register
    reg [2:0] y;
    
    // Initialize state register
    initial begin : blk_1
        y = 3'b000;
    end
    
    // Next state reg (combinational)
    wire [2:0] y_next;
    
    // y_next[2]: Set when transitioning to states 1xx (only state 100)
    // From 001 with x=1 → 100
    // From 100 with x=1 → 100
    assign y_next[2] = (y == 3'b001 && x) || 
                       (y == 3'b100 && x);
    
    // y_next[1]: Set when transitioning to states x1x (states 010, 011)
    // From 010 with x=0 → 010
    // From 011 with x=1 → 010
    // From 100 with x=0 → 011
    assign y_next[1] = (y == 3'b010 && ~x) || 
                       (y == 3'b011 && x) || 
                       (y == 3'b100 && ~x);
    
    // y_next[0]: Set when transitioning to states xx1 (states 001, 011)
    // From 000 with x=1 → 001
    // From 001 with x=0 → 001
    // From 010 with x=1 → 001
    // From 011 with x=0 → 001
    // From 100 with x=0 → 011  <-- THIS WAS MISSING
    assign y_next[0] = (y == 3'b000 && x) || 
                       (y == 3'b001 && ~x) || 
                       (y == 3'b010 && x) || 
                       (y == 3'b011 && ~x) ||
                       (y == 3'b100 && ~x);
    
    // State register with synchronous reset
    always @(posedge clk) begin : blk_2
        if (reset)
            y <= 3'b000;
        else
            y <= y_next;
    end
    
    // Output z (Moore output - depends only on current state)
    // z = 1 when in state 011 or 100
    assign z = (y == 3'b011) || (y == 3'b100);

endmodule
