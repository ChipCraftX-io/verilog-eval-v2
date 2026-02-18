module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

    // State encoding
    parameter IDLE      = 4'd0;
    parameter GOT_1     = 4'd1;
    parameter GOT_11    = 4'd2;
    parameter GOT_110   = 4'd3;
    parameter SHIFT_0   = 4'd4;
    parameter SHIFT_1   = 4'd5;
    parameter SHIFT_2   = 4'd6;
    parameter SHIFT_3   = 4'd7;
    parameter COUNTING  = 4'd8;
    parameter DONE      = 4'd9;
    
    reg [3:0] state, next_state;
    
    // State register with synchronous reset
    always @(posedge clk) begin : blk_1
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end
    
    // Next state reg
    always @(*) begin : blk_2
        case (state)
            IDLE: begin
                // Waiting for first '1'
                if (data)
                    next_state = GOT_1;
                else
                    next_state = IDLE;
            end
            
            GOT_1: begin
                // Saw one '1', need another '1' for "11"
                if (data)
                    next_state = GOT_11;  // Got "11"
                else
                    next_state = IDLE;     // Reset on '0'
            end
            
            GOT_11: begin
                // Saw "11", need '0' for "110"
                if (data)
                    next_state = GOT_11;   // Stay here on '1' (overlapping pattern)
                else
                    next_state = GOT_110;  // Got "110"
            end
            
            GOT_110: begin
                // Saw "110", need '1' for "1101"
                if (data)
                    next_state = SHIFT_0;  // Pattern complete! Start shifting
                else
                    next_state = IDLE;     // Reset on '0'
            end
            
            SHIFT_0: begin
                // First shift cycle
                next_state = SHIFT_1;
            end
            
            SHIFT_1: begin
                // Second shift cycle
                next_state = SHIFT_2;
            end
            
            SHIFT_2: begin
                // Third shift cycle
                next_state = SHIFT_3;
            end
            
            SHIFT_3: begin
                // Fourth shift cycle (last)
                next_state = COUNTING;
            end
            
            COUNTING: begin
                // Wait for counters to finish
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNTING;
            end
            
            DONE: begin
                // Wait for user acknowledgment
                if (ack)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end
    
    // Moore outputs - derived from state only
    assign shift_ena = (state == SHIFT_0) || (state == SHIFT_1) || 
                       (state == SHIFT_2) || (state == SHIFT_3);
    
    assign counting = (state == COUNTING);
    
    assign done = (state == DONE);

endmodule
