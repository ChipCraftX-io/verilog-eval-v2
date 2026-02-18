module TopModule (
    input  [254:0] in,
    output [7:0]   out
);
  integer i, j;

    // Internal signals for hierarchical counting
    // Level 1: Count bits in 8-wire chunks
    // We have 31 full 8-wire chunks (248 bits) + 1 chunk of 7 bits
    reg [3:0] count_l1 [0:31];  // 32 chunks, each needs 4 bits max (0-8)
    
    // Level 2: Sum pairs from level 1
    reg [4:0] count_l2 [0:15];  // 16 sums, each needs 5 bits max (0-16)
    
    // Level 3: Sum pairs from level 2
    reg [5:0] count_l3 [0:7];   // 8 sums, each needs 6 bits max (0-32)
    
    // Level 4: Sum pairs from level 3
    reg [6:0] count_l4 [0:3];   // 4 sums, each needs 7 bits max (0-64)
    
    // Level 5: Sum pairs from level 4
    reg [7:0] count_l5 [0:1];   // 2 sums, each needs 8 bits max (0-128)
    
    // Final sum
    reg [7:0] final_count;
    // Combinational reg for population count
    always @(*) begin : blk_1
        // Level 1: Count bits in each 8-bit (or 7-bit) chunk
        for (i = 0; i < 31; i = i + 1) begin
            count_l1[i] = in[i*8 + 0] + in[i*8 + 1] + in[i*8 + 2] + in[i*8 + 3] +
                          in[i*8 + 4] + in[i*8 + 5] + in[i*8 + 6] + in[i*8 + 7];
        end
        // Last chunk is only 7 bits (248 to 254)
        count_l1[31] = in[248] + in[249] + in[250] + in[251] + 
                       in[252] + in[253] + in[254];
        
        // Level 2: Sum pairs from level 1 (32 -> 16)
        for (i = 0; i < 16; i = i + 1) begin
            count_l2[i] = count_l1[i*2] + count_l1[i*2 + 1];
        end
        
        // Level 3: Sum pairs from level 2 (16 -> 8)
        for (i = 0; i < 8; i = i + 1) begin
            count_l3[i] = count_l2[i*2] + count_l2[i*2 + 1];
        end
        
        // Level 4: Sum pairs from level 3 (8 -> 4)
        for (i = 0; i < 4; i = i + 1) begin
            count_l4[i] = count_l3[i*2] + count_l3[i*2 + 1];
        end
        
        // Level 5: Sum pairs from level 4 (4 -> 2)
        for (i = 0; i < 2; i = i + 1) begin
            count_l5[i] = count_l4[i*2] + count_l4[i*2 + 1];
        end
        
        // Final: Sum the last two values
        final_count = count_l5[0] + count_l5[1];
    end
    
    // Output assignment
    assign out = final_count;

endmodule
