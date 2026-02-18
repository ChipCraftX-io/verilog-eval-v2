module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // State encoding
    parameter [3:0] S0    = 4'd0,  // 0 consecutive 1s
                    S1    = 4'd1,  // 1 consecutive 1
                    S2    = 4'd2,  // 2 consecutive 1s
                    S3    = 4'd3,  // 3 consecutive 1s
                    S4    = 4'd4,  // 4 consecutive 1s
                    S5    = 4'd5,  // 5 consecutive 1s
                    S6    = 4'd6,  // 6 consecutive 1s
                    SERR  = 4'd7,  // Error: 7+ consecutive 1s
                    SDISC = 4'd8,  // Discard: detected 01111110
                    SFLAG = 4'd9;  // Flag: detected 011111110
    
    reg [3:0] state, next_state;
    
    // Moore outputs - based only on current state
    assign disc = (state == SDISC);
    assign flag = (state == SFLAG);
    assign err  = (state == SERR);
    
    // Next state reg (combinational)
    always @(*) begin : blk_1
        case (state)
            S0: begin
                // 0 consecutive 1s
                if (in)
                    next_state = S1;
                else
                    next_state = S0;
            end
            
            S1: begin
                // 1 consecutive 1
                if (in)
                    next_state = S2;
                else
                    next_state = S0;
            end
            
            S2: begin
                // 2 consecutive 1s
                if (in)
                    next_state = S3;
                else
                    next_state = S0;
            end
            
            S3: begin
                // 3 consecutive 1s
                if (in)
                    next_state = S4;
                else
                    next_state = S0;
            end
            
            S4: begin
                // 4 consecutive 1s
                if (in)
                    next_state = S5;
                else
                    next_state = S0;
            end
            
            S5: begin
                // 5 consecutive 1s
                if (in)
                    next_state = S6;      // Continue to 6
                else
                    next_state = SDISC;   // Bit stuffing detected
            end
            
            S6: begin
                // 6 consecutive 1s
                if (in)
                    next_state = SERR;    // 7+ ones = error
                else
                    next_state = SFLAG;   // Flag detected
            end
            
            SERR: begin
                // Error state - stay until we see a 0
                if (in)
                    next_state = SERR;
                else
                    next_state = S0;
            end
            
            SDISC: begin
                // After discard, restart counting
                if (in)
                    next_state = S1;      // New 1 starts counting
                else
                    next_state = S0;
            end
            
            SFLAG: begin
                // After flag, restart counting
                if (in)
                    next_state = S1;      // New 1 starts counting
                else
                    next_state = S0;
            end
            
            default: next_state = S0;
        endcase
    end
    
    // State register (sequential)
    always @(posedge clk) begin : blk_2
        if (reset)
            state <= S0;  // Reset behaves as if previous input was 0
        else
            state <= next_state;
    end
    
    // Initialize state for simulation
    initial begin : blk_3
        state = S0;
    end

endmodule
