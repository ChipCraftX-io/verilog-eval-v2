module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding
    parameter WALK_LEFT  = 1'b0;
    parameter WALK_RIGHT = 1'b1;
    
    // State register
    reg state, next_state;
    
    // Next state reg (combinational)
    always @(*) begin : blk_1
        case (state)
            WALK_LEFT: begin
                // Walking left: only bump_left makes us turn right
                if (bump_left)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;
            end
            
            WALK_RIGHT: begin
                // Walking right: only bump_right makes us turn left
                if (bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end
            
            default: begin
                next_state = WALK_LEFT;
            end
        endcase
    end
    
    // State register with asynchronous reset
    always @(posedge clk, posedge areset) begin : blk_2
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end
    
    // Moore outputs (combinational, depend only on state)
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    
    // Initialize state for simulation
    initial begin : blk_3
        state = WALK_LEFT;
    end

endmodule
