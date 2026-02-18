module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding - using 2 bits for 4 states
    parameter A  = 2'b00;  // Wait for s=1
    parameter B0 = 2'b01;  // First cycle of 3-cycle window
    parameter B1 = 2'b10;  // Second cycle of 3-cycle window
    parameter B2 = 2'b11;  // Third cycle of 3-cycle window
    
    reg [1:0] state, next_state;
    reg [1:0] count;      // Count of w=1 in current window (0 to 3)
    reg [1:0] next_count;
    reg z_reg, next_z;
    
    // State register
    always @(posedge clk) begin : blk_1
        if (reset) begin
            state <= A;
            count <= 2'b00;
            z_reg <= 1'b0;
        end else begin
            state <= next_state;
            count <= next_count;
            z_reg <= next_z;
        end
    end
    
    // Next state reg and counting reg
    always @(*) begin : blk_2
        // Default assignments
        next_state = state;
        next_count = count;
        next_z = 1'b0;
        
        case (state)
            A: begin
                // Wait for s=1 to start
                next_count = 2'b00;
                next_z = 1'b0;
                if (s) begin
                    next_state = B0;
                end else begin
                    next_state = A;
                end
            end
            
            B0: begin
                // First cycle of window - start counting
                next_count = w ? 2'b01 : 2'b00;
                next_state = B1;
                next_z = 1'b0;
            end
            
            B1: begin
                // Second cycle of window - accumulate count
                next_count = count + {1'b0, w};
                next_state = B2;
                next_z = 1'b0;
            end
            
            B2: begin
                // Third cycle of window - check if exactly 2 ones
                // Set z based on total count (count + current w)
                next_z = ((count + {1'b0, w}) == 2'b10) ? 1'b1 : 1'b0;
                
                // Start next 3-cycle window from B0
                next_count = 2'b00;
                next_state = B0;
            end
            
            default: begin
                next_state = A;
                next_count = 2'b00;
                next_z = 1'b0;
            end
        endcase
    end
    
    // Output assignment
    assign z = z_reg;
    
    // Initialize output register for simulation
    initial begin : blk_3
        z_reg = 1'b0;
    end

endmodule
