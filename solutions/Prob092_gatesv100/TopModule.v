module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);
  integer i;

    // Local parameter for loop iteration
    // Registers for combinational outputs
    reg [99:0] both_reg;
    reg [99:0] any_reg;
    reg [99:0] diff_reg;
    
    // Combinational reg for all three outputs
    always @(*) begin : blk_1
        // Initialize all outputs
        both_reg = 100'b0;
        any_reg = 100'b0;
        diff_reg = 100'b0;
        
        // Process each wire for (i = 0; i < 100; i = i + 1) begin
            // out_both: current wire AND left neighbor
            if (i == 99) begin
                // No left neighbor for wire 99
                both_reg[i] = 1'b0;
            end else begin
                // Check if both in[i] and in[i+1] (left neighbor) are 1
                both_reg[i] = in[i] & in[i+1];
            end
            
            // out_any: current wire OR right neighbor
            if (i == 0) begin
                // No right neighbor for wire 0
                any_reg[i] = 1'b0;
            end else begin
                // Check if either in[i] or in[i-1] (right neighbor) is 1
                any_reg[i] = in[i] | in[i-1];
            end
            
            // out_different: current wire XOR left neighbor (with wraparound)
            if (i == 99) begin
                // Wraparound: compare in[99] with in[0]
                diff_reg[i] = in[i] ^ in[0];
            end else begin
                // Compare in[i] with in[i+1] (left neighbor)
                diff_reg[i] = in[i] ^ in[i+1];
            end
        end
    end
    
    // Assign outputs
    assign out_both = both_reg;
    assign out_any = any_reg;
    assign out_different = diff_reg;

endmodule
