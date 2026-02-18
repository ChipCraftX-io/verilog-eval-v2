module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    // State encoding
    localparam SEARCH = 3'b000;  // Looking for byte 1 (in[3]=1)
    localparam BYTE2  = 3'b001;  // Received byte 1, expecting byte 2
    localparam BYTE3  = 3'b010;  // Received byte 2, expecting byte 3
    localparam DONE_ST = 3'b011; // Message complete
    
    reg [2:0] state, next_state;
    
    // State register with synchronous reset
    always @(posedge clk) begin : blk_1
        if (reset)
            state <= SEARCH;
        else
            state <= next_state;
    end
    
    // Next state reg
    always @(*) begin : blk_2
        case (state)
            SEARCH: begin
                // Wait for a byte with in[3]=1 (start of message)
                if (in[3])
                    next_state = BYTE2;
                else
                    next_state = SEARCH;
            end
            
            BYTE2: begin
                // Any byte is accepted as byte 2
                // Move to BYTE3 state
                next_state = BYTE3;
            end
            
            BYTE3: begin
                // Receiving byte 3, move to DONE state
                next_state = DONE_ST;
            end
            
            DONE_ST: begin
                // Message complete
                // If current byte has in[3]=1, it's the start of next message
                if (in[3])
                    next_state = BYTE2;
                else
                    next_state = SEARCH;
            end
            
            default: begin
                next_state = SEARCH;
            end
        endcase
    end
    
    // Output reg (Moore machine - output depends only on state)
    // done is asserted when we're in DONE_ST state
    assign done = (state == DONE_ST);
    
    // Initialize state for simulation
    initial begin : blk_3
        state = SEARCH;
    end

endmodule
