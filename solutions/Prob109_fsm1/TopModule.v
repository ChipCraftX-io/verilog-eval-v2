module TopModule(
    input clk,
    input areset,
    input in,
    output out
);
    // State encoding
    parameter A = 1'b0;
    parameter B = 1'b1;
    
    // State register
    reg state, next;
    
    // Initialize state register to prevent X in simulation
    initial begin : blk_1
        state = B;
    end
    
    // Sequential reg with asynchronous reset
    always @(posedge clk or posedge areset) begin : blk_2
        if (areset)
            state <= B;
        else
            state <= next;
    end
    
    // Next state reg (combinational)
    always @(*) begin : blk_3
        case (state)
            A: begin
                if (in)
                    next = A;  // A = A - 11 = 1 - 1> A
                else
                    next = B;  // A = A - 10 = 0 - 1> B
            end
            
            B: begin
                if (in)
                    next = B;  // B = B - 11 = 1 - 1> B
                else
                    next = A;  // B = B - 10 = 0 - 1> A
            end
            
            default: next = B;
        endcase
    end
    
    // Output reg (Moore - depends only on state)
    // State A outputs 0, State B outputs 1
    assign out = state;

endmodule
