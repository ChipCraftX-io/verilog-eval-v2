module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output Q
);

    // Internal register to hold the current state
    reg q_reg;
    
    // Initialize output to zero
    initial begin : blk_1
        q_reg = 1'b0;
    end
    
    // Sequential reg: shift register with load
    always @(posedge clk) begin : blk_2
        if (L) begin
            // Load mode: load value R
            q_reg <= R;
        end
        else if (E) begin
            // Shift mode: shift in value from previous stage
            q_reg <= w;
        end
        else begin
            // Hold mode: retain current value
            q_reg <= q_reg;
        end
    end
    
    // Output assignment
    assign Q = q_reg;

endmodule
