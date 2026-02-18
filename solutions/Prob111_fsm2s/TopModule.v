module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);
    // State encoding
    parameter OFF = 1'b0;
    parameter ON  = 1'b1;
    
    // State register
    reg state, next_state;
    
    // Initialize state register
    initial begin : blk_1
        state = OFF;
    end
    
    // Next state reg (combinational)
    always @(*) begin : blk_2
        case (state)
            OFF: begin
                if (j)
                    next_state = ON;
                else
                    next_state = OFF;
            end
            
            ON: begin
                if (k)
                    next_state = OFF;
                else
                    next_state = ON;
            end
            
            default: next_state = OFF;
        endcase
    end
    
    // State register update (sequential)
    always @(posedge clk) begin : blk_3
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end
    
    // Moore output - depends only on current state
    assign out = (state == ON);

endmodule
