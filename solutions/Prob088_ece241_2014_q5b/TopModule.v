module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state encoding
    localparam A = 2'b01;
    localparam B = 2'b10;
    
    // State registers
    reg [1:0] state, next_state;
    
    // Initialize state register to prevent X propagation
    initial begin : blk_1
        state = A;
    end
    
    // Sequential reg: state register with asynchronous reset
    always @(posedge clk or posedge areset) begin : blk_2
        if (areset)
            state <= A;
        else
            state <= next_state;
    end
    
    // Next state reg (one-hot encoding)
    // For one-hot, trace each state's incoming transitions:
    // next_state[A] = (state==A && x==0) || other transitions to A (none)
    // next_state[B] = (state==A && x==1) || (state==B && x==0) || (state==B && x==1)
    always @(*) begin : blk_3
        next_state = 2'b00; // Default to no state (will be overridden)
        
        // State A transitions
        if (state[0]) begin  // state == A
            if (x == 1'b0)
                next_state = A;  // A -> A on x=0
            else
                next_state = B;  // A -> B on x=1
        end
        
        // State B transitions
        if (state[1]) begin  // state == B
            // B stays in B for both x=0 and x=1
            next_state = B;
        end
    end
    
    // Output reg (Mealy - depends on current state AND input)
    // z = 0 when: (state==A && x==0) || (state==B && x==1)
    // z = 1 when: (state==A && x==1) || (state==B && x==0)
    reg z_reg;
    always @(*) begin : blk_4
        z_reg = 1'b0;
        
        if (state[0]) begin  // state == A
            if (x == 1'b1)
                z_reg = 1'b1;  // A with x=1 -> z=1
            else
                z_reg = 1'b0;  // A with x=0 -> z=0
        end
        else if (state[1]) begin  // state == B
            if (x == 1'b0)
                z_reg = 1'b1;  // B with x=0 -> z=1
            else
                z_reg = 1'b0;  // B with x=1 -> z=0
        end
    end
    
    assign z = z_reg;

endmodule
