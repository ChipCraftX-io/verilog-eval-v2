module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;
    
    // State register
    reg state, next_state;
    
    // Initialize state register to OFF
    initial begin : blk_1
        state = OFF;
    end
    
    // Sequential reg: state register with asynchronous reset
    always @(posedge clk or posedge areset) begin : blk_2
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end
    
    // Combinational reg: next state reg
    always @(*) begin : blk_3
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
    
    // Moore output: depends only on current state
    assign out = (state == ON);

endmodule
