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

    // State encoding - 7 states to preserve direction and handle splat
    localparam WL = 3'd0;      // Walk Left
    localparam WR = 3'd1;      // Walk Right
    localparam FALLL = 3'd2;   // Fall Left
    localparam FALLR = 3'd3;   // Fall Right
    localparam DIGL = 3'd4;    // Dig Left
    localparam DIGR = 3'd5;    // Dig Right
    localparam DEAD = 3'd6;    // Splat (dead)

    reg [2:0] state, next_state;
    reg [4:0] fall_counter;    // Counter to track fall duration (needs to count to 20)

    // State transition reg
    always @(*) begin : blk_1
        case (state)
            WL: begin
                // Priority: !ground > dig > bump > stay
                if (!ground)
                    next_state = FALLL;
                else if (dig)
                    next_state = DIGL;
                else if (bump_left)    // ONLY check bump_left for WL
                    next_state = WR;
                else
                    next_state = WL;
            end

            WR: begin
                // Priority: !ground > dig > bump > stay
                if (!ground)
                    next_state = FALLR;
                else if (dig)
                    next_state = DIGR;
                else if (bump_right)   // ONLY check bump_right for WR
                    next_state = WL;
                else
                    next_state = WR;
            end

            FALLL: begin
                // Check for splat when hitting ground
                if (ground) begin
                    if (fall_counter >= 5'd20)
                        next_state = DEAD;
                    else
                        next_state = WL;
                end else
                    next_state = FALLL;
            end

            FALLR: begin
                // Check for splat when hitting ground
                if (ground) begin
                    if (fall_counter >= 5'd20)
                        next_state = DEAD;
                    else
                        next_state = WR;
                end else
                    next_state = FALLR;
            end

            DIGL: begin
                // Dig until ground disappears, then fall in same direction
                if (!ground)
                    next_state = FALLL;
                else
                    next_state = DIGL;
            end

            DIGR: begin
                // Dig until ground disappears, then fall in same direction
                if (!ground)
                    next_state = FALLR;
                else
                    next_state = DIGR;
            end

            DEAD: begin
                // Stay dead forever (until reset)
                next_state = DEAD;
            end

            default: begin
                next_state = WL;
            end
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin : blk_2
        if (areset)
            state <= WL;
        else
            state <= next_state;
    end

    // Fall counter - separate sequential block
    // Counts cycles while falling, caps at 20
    always @(posedge clk or posedge areset) begin : blk_3
        if (areset) begin
            fall_counter <= 5'd0;
        end else begin
            if (state == FALLL || state == FALLR) begin
                // Increment counter while falling, but cap at 20
                if (fall_counter < 5'd20)
                    fall_counter <= fall_counter + 5'd1;
            end else begin
                // Reset counter when not falling
                fall_counter <= 5'd0;
            end
        end
    end

    // Moore outputs - derived from state only
    assign walk_left = (state == WL);
    assign walk_right = (state == WR);
    assign aaah = (state == FALLL) || (state == FALLR);
    assign digging = (state == DIGL) || (state == DIGR);

endmodule
