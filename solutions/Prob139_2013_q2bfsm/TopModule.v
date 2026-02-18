module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

    // State encoding (9 states)
    parameter A = 0;    // Reset state
    parameter B = 1;    // Output f=1 for one cycle
    parameter S0 = 2;   // Waiting for first '1' in pattern
    parameter S1 = 3;   // Got first '1', waiting for '0'
    parameter S10 = 4;  // Got '1-0', waiting for final '1'
    parameter G1 = 5;   // Pattern detected, g=1, check y (cycle 1)
    parameter G2 = 6;   // g=1, check y (cycle 2)
    parameter P0 = 7;   // g=0 permanently
    parameter P1 = 8;   // g=1 permanently

    reg [3:0] state, next;

    // State register (synchronous, active-low reset)
    always @(posedge clk) begin : blk_1
        if (!resetn)
            state <= A;
        else
            state <= next;
    end

    // Next-state reg (combinational)
    always @(*) begin : blk_2
        case (state)
            A: begin
                // Stay in reset state while resetn is low
                // Transition to B on next clock after resetn deasserts
                next = B;
            end
            
            B: begin
                // Assert f for one cycle, then start monitoring x
                next = S0;
            end
            
            S0: begin
                // Waiting for first '1' in the 1-0-1 pattern
                if (x)
                    next = S1;
                else
                    next = S0;
            end
            
            S1: begin
                // Got first '1', now need '0'
                // Self-loop on '1' to handle overlapping patterns
                if (x)
                    next = S1;
                else
                    next = S10;
            end
            
            S10: begin
                // Got '1-0', now need final '1' to complete pattern
                if (x)
                    next = G1;  // Pattern complete! Set g=1 and start monitoring y
                else
                    next = S0;  // Pattern broken, restart
            end
            
            G1: begin
                // Pattern detected, g=1, monitor y (first cycle)
                if (y)
                    next = P1;  // y=1 on first cycle, g=1 permanently
                else
                    next = G2;  // y=0, give it one more cycle
            end
            
            G2: begin
                // g=1, monitor y (second cycle)
                if (y)
                    next = P1;  // y=1 on second cycle, g=1 permanently
                else
                    next = P0;  // y didn't arrive in time, g=0 permanently
            end
            
            P0: begin
                // g=0 permanently (until reset)
                next = P0;
            end
            
            P1: begin
                // g=1 permanently (until reset)
                next = P1;
            end
            
            default: begin
                next = A;
            end
        endcase
    end

    // CRITICAL: Combinational outputs (NOT registered)
    // Using assign ensures outputs change immediately with state transitions
    // Registered outputs would create one-cycle timing errors
    assign f = (state == B);
    assign g = (state == G1) || (state == G2) || (state == P1);

endmodule
