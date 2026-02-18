module TopModule (
    input clk,
    input areset,
    input in,
    output out
);
    // State encoding - using 2 bits for 4 states
    parameter [1:0] A = 2'b00;
    parameter [1:0] B = 2'b01;
    parameter [1:0] C = 2'b10;
    parameter [1:0] D = 2'b11;
    
    // State registers
    reg [1:0] state, next_state;
    
    // Initialize state register
    initial begin : blk_1
        state = A;
    end
    
    // Sequential reg - state register with async reset
    always @(posedge clk or posedge areset) begin : blk_2
        if (areset)
            state <= A;
        else
            state <= next_state;
    end
    
    // Combinational reg - next state reg
    always @(*) begin : blk_3
        case (state)
            A: begin
                if (in)
                    next_state = B;
                else
                    next_state = A;
            end
            
            B: begin
                if (in)
                    next_state = B;
                else
                    next_state = C;
            end
            
            C: begin
                if (in)
                    next_state = D;
                else
                    next_state = A;
            end
            
            D: begin
                if (in)
                    next_state = B;
                else
                    next_state = C;
            end
            
            default: next_state = A;
        endcase
    end
    
    // Moore output - depends only on current state
    // Output is 1 only in state D
    assign out = (state == D);

endmodule
