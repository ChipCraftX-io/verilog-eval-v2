module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding: 6 states to preserve direction through fall and dig
    localparam WL = 3'd0;      // Walk Left
    localparam WR = 3'd1;      // Walk Right
    localparam FALLL = 3'd2;   // Fall Left (resume walking left)
    localparam FALLR = 3'd3;   // Fall Right (resume walking right)
    localparam DIGL = 3'd4;    // Dig Left (resume walking left)
    localparam DIGR = 3'd5;    // Dig Right (resume walking right)
    
    reg [2:0] state, next;
    
    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin : blk_1
        if (areset)
            state <= WL;  // Reset to walk left
        else
            state <= next;
    end
    
    // Next-state reg
    // Priority: !ground > dig > bump > continue
    always @(*) begin : blk_2
        case (state)
            WL: begin
                if (!ground)
                    next = FALLL;           // Fall has highest priority
                else if (dig)
                    next = DIGL;            // Dig has second priority
                else if (bump_left)
                    next = WR;              // Bump changes direction
                else
                    next = WL;              // Continue walking left
            end
            
            WR: begin
                if (!ground)
                    next = FALLR;           // Fall has highest priority
                else if (dig)
                    next = DIGR;            // Dig has second priority
                else if (bump_right)
                    next = WL;              // Bump changes direction
                else
                    next = WR;              // Continue walking right
            end
            
            FALLL: begin
                if (ground)
                    next = WL;              // Resume walking left when ground reappears
                else
                    next = FALLL;           // Continue falling
            end
            
            FALLR: begin
                if (ground)
                    next = WR;              // Resume walking right when ground reappears
                else
                    next = FALLR;           // Continue falling
            end
            
            DIGL: begin
                if (!ground)
                    next = FALLL;           // Fall when dig through ground
                else
                    next = DIGL;            // Continue digging while ground present
            end
            
            DIGR: begin
                if (!ground)
                    next = FALLR;           // Fall when dig through ground
                else
                    next = DIGR;            // Continue digging while ground present
            end
            
            default: next = WL;
        endcase
    end
    
    // Moore outputs - derived from state alone
    assign walk_left = (state == WL);
    assign walk_right = (state == WR);
    assign aaah = (state == FALLL) || (state == FALLR);
    assign digging = (state == DIGL) || (state == DIGR);

endmodule
