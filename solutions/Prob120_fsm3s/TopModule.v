module TopModule (
    input clk,
    input reset,
    input in,
    output out
);
    // State encoding - using 2 bits for 4 states
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;
    
    reg [1:0] state, next_state;
    
    // Sequential reg - state register with synchronous reset
    always @(posedge clk) begin : blk_1
        if (reset)
            state <= A;
        else
            state <= next_state;
    end
    
    // Combinational reg - next state decoder
    always @(*) begin : blk_2
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
    
    // Moore output reg - output depends only on current state
    assign out = (state == D);

endmodule
