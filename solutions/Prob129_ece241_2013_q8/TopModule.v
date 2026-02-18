module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);
    // State encoding for 3 states
    localparam S0 = 2'b00;  // IDLE or saw '0'
    localparam S1 = 2'b01;  // Saw '1'
    localparam S2 = 2'b10;  // Saw '10'
    
    reg [1:0] state, next_state;
    
    // State register with asynchronous negative-edge triggered reset
    always @(posedge clk or negedge aresetn) begin : blk_1
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end
    
    // Next state reg (combinational)
    always @(*) begin : blk_2
        case (state)
            S0: begin
                // IDLE or saw '0'
                if (x)
                    next_state = S1;  // Start sequence with '1'
                else
                    next_state = S0;  // Stay in S0 on '0'
            end
            
            S1: begin
                // Saw '1'
                if (x)
                    next_state = S1;  // Another '1', self-loop for overlapping
                else
                    next_state = S2;  // Got '10'
            end
            
            S2: begin
                // Saw '10'
                if (x)
                    next_state = S1;  // Complete '101', go to S1 (this '1' starts new sequence)
                else
                    next_state = S0;  // Broken sequence, reset
            end
            
            default: next_state = S0;
        endcase
    end
    
    // Mealy output reg (combinational)
    // z asserts when we're in S2 (saw '10') and x=1 (completing '101')
    assign z = (state == S2) && x;

endmodule
