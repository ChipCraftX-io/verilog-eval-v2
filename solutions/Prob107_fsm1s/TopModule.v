module TopModule(
    input clk,
    input reset,
    input in,
    output out
);
    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;
    
    // State register
    reg state, next_state;
    
    // Initialize state register
    initial begin : blk_1
        state = B;  // Reset state is B
    end
    
    // Sequential reg: State register with synchronous reset
    always @(posedge clk) begin : blk_2
        if (reset)
            state <= B;  // Reset to state B
        else
            state <= next_state;
    end
    
    // Combinational reg: Next state reg
    always @(*) begin : blk_3
        case (state)
            B: begin
                if (in == 1'b0)
                    next_state = A;  // B = B - 1in=0 = 0 - 1> A
                else
                    next_state = B;  // B = B - 1in=1 = 1 - 1> B
            end
            
            A: begin
                if (in == 1'b0)
                    next_state = B;  // A = A - 1in=0 = 0 - 1> B
                else
                    next_state = A;  // A = A - 1in=1 = 1 - 1> A
            end
            
            default: next_state = B;
        endcase
    end
    
    // Moore output: Output depends only on current state
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule
