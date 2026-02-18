module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // State encoding - 4 states: 2 walk + 2 fall
    parameter WL = 2'd0;      // Walk Left
    parameter WR = 2'd1;      // Walk Right
    parameter FALLL = 2'd2;   // Fall Left (will resume walking left)
    parameter FALLR = 2'd3;   // Fall Right (will resume walking right)
    
    reg [1:0] state, next;
    
    // State register with async reset
    always @(posedge clk, posedge areset) begin : blk_1
        if (areset)
            state <= WL;  // Reset to walk left
        else
            state <= next;
    end
    
    // Next state reg
    // Priority: !ground > bump > stay
    always @(*) begin : blk_2
        case (state)
            WL: begin
                if (!ground)
                    next = FALLL;  // Ground disappears, fall while facing left
                else if (bump_left)
                    next = WR;     // Bumped on left, turn right
                else
                    next = WL;     // Continue walking left
            end
            
            WR: begin
                if (!ground)
                    next = FALLR;  // Ground disappears, fall while facing right
                else if (bump_right)
                    next = WL;     // Bumped on right, turn left
                else
                    next = WR;     // Continue walking right
            end
            
            FALLL: begin
                if (ground)
                    next = WL;     // Ground reappears, resume walking left
                else
                    next = FALLL;  // Continue falling (bumps ignored)
            end
            
            FALLR: begin
                if (ground)
                    next = WR;     // Ground reappears, resume walking right
                else
                    next = FALLR;  // Continue falling (bumps ignored)
            end
            
            default: next = WL;
        endcase
    end
    
    // Moore outputs - depend only on current state
    assign walk_left = (state == WL);
    assign walk_right = (state == WR);
    assign aaah = (state == FALLL) || (state == FALLR);

endmodule
