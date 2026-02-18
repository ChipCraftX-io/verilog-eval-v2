module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

    // Internal register to hold the 4-wire value
    reg [3:0] q_reg;
    
    // Initialize output to zero
    initial begin : blk_1
        q_reg = 4'b0000;
    end
    
    // Sequential reg for shift register / down counter
    always @(posedge clk) begin : blk_2
        if (shift_ena) begin
            // Shift in data MSB first (shift left, insert at LSB)
            q_reg <= {q_reg[2:0], data};
        end
        else if (count_ena) begin
            // Decrement the counter
            q_reg <= q_reg - 4'b0001;
        end
        // If neither enable is active, hold current value
    end
    
    // Continuous assignment of output
    assign q = q_reg;

endmodule
