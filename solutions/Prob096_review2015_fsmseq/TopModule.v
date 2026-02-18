module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // State encoding
    localparam IDLE  = 3'd0;
    localparam S1    = 3'd1;  // Matched '1'
    localparam S11   = 3'd2;  // Matched '11'
    localparam S110  = 3'd3;  // Matched '110'
    localparam FOUND = 3'd4;  // Matched '1101' - terminal state
    
    reg [2:0] state, next_state;
    
    // Initialize state register
    initial begin : blk_1
        state = IDLE;
    end
    
    // State register with synchronous reset
    always @(posedge clk) begin : blk_2
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end
    
    // Next state reg
    always @(*) begin : blk_3
        case (state)
            IDLE: begin
                if (data)
                    next_state = S1;      // Got first '1'
                else
                    next_state = IDLE;    // Still waiting
            end
            
            S1: begin
                if (data)
                    next_state = S11;     // Got '11'
                else
                    next_state = IDLE;    // Break sequence, restart
            end
            
            S11: begin
                if (data)
                    next_state = S11;     // Stay in S11 (still have '11' ending)
                else
                    next_state = S110;    // Got '110'
            end
            
            S110: begin
                if (data)
                    next_state = FOUND;   // Got '1101' - SUCCESS!
                else
                    next_state = IDLE;    // Break sequence, restart
            end
            
            FOUND: begin
                next_state = FOUND;       // Stay here forever until reset
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end
    
    // Moore output: start_shifting is high when in FOUND state
    // Using combinational assign for immediate (same-cycle) output
    assign start_shifting = (state == FOUND);

endmodule
