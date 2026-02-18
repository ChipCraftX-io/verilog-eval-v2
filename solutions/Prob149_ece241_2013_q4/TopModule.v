module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);
    // Six-state FSM encoding water level and direction
    // A2: Below s[0] (always entered from above in steady state)
    // B1: Between s[0] and s[1], rising (arrived from below)
    // B2: Between s[0] and s[1], falling (arrived from above)
    // C1: Between s[1] and s[2], rising (arrived from below)
    // C2: Between s[1] and s[2], falling (arrived from above)
    // D1: Above s[2] (always entered from below)
    parameter A2 = 3'd0;
    parameter B1 = 3'd1;
    parameter B2 = 3'd2;
    parameter C1 = 3'd3;
    parameter C2 = 3'd4;
    parameter D1 = 3'd5;
    
    reg [2:0] state, next;
    
    // State register with synchronous reset
    // Reset to A2 (below all sensors, water low for long time)
    always @(posedge clk) begin : blk_1
        if (reset)
            state <= A2;
        else
            state <= next;
    end
    
    // Next state reg (combinational)
    // Transitions based on current state and sensor readings
    always @(*) begin : blk_2
        case (state)
            A2: begin
                // Below s[0]: if s[0] asserts, water rising to B1
                next = s[0] ? B1 : A2;
            end
            
            B1: begin
                // Between s[0] and s[1], rising
                if (s[1])
                    next = C1;  // Water rose to s[1], continue rising
                else if (s[0])
                    next = B1;  // Still between s[0] and s[1]
                else
                    next = A2;  // Water fell below s[0]
            end
            
            B2: begin
                // Between s[0] and s[1], falling
                if (s[1])
                    next = C1;  // Water rose back to s[1], now rising
                else if (s[0])
                    next = B2;  // Still between s[0] and s[1]
                else
                    next = A2;  // Water fell below s[0]
            end
            
            C1: begin
                // Between s[1] and s[2], rising
                if (s[2])
                    next = D1;  // Water rose to s[2], continue rising
                else if (s[1])
                    next = C1;  // Still between s[1] and s[2]
                else
                    next = B2;  // Water fell below s[1], now falling
            end
            
            C2: begin
                // Between s[1] and s[2], falling
                if (s[2])
                    next = D1;  // Water rose back to s[2], now rising
                else if (s[1])
                    next = C2;  // Still between s[1] and s[2]
                else
                    next = B2;  // Water fell below s[1], continue falling
            end
            
            D1: begin
                // Above s[2]: if s[2] deasserts, water falling to C2
                next = s[2] ? D1 : C2;
            end
            
            default: next = A2;
        endcase
    end
    
    // Output reg (combinational, Moore-style)
    // Outputs depend ONLY on current state
    // CRITICAL: dfr=1 for FALLING states (supplement compensates for loss)
    //          dfr=0 for RISING states (water already increasing)
    reg [3:0] flow_outputs;
    
    always @(*) begin : blk_3
        case (state)
            A2: flow_outputs = 4'b1111;  // Below s[0]: all valves open (falling/low)
            B1: flow_outputs = 4'b0110;  // Between s[0],s[1] rising: fr1,fr0 (no supplement)
            B2: flow_outputs = 4'b0111;  // Between s[0],s[1] falling: fr1,fr0,dfr
            C1: flow_outputs = 4'b0010;  // Between s[1],s[2] rising: fr0 (no supplement)
            C2: flow_outputs = 4'b0011;  // Between s[1],s[2] falling: fr0,dfr
            D1: flow_outputs = 4'b0000;  // Above s[2]: no flow needed
            default: flow_outputs = 4'b0000;
        endcase
    end
    
    // Assign outputs from combined flow_outputs register
    assign {fr2, fr1, fr0, dfr} = flow_outputs;

endmodule
