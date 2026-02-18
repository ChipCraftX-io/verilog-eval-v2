module TopModule (
    input  [3:0] in,
    output [1:0] pos
);

    // Priority encoder: Find position of first '1' bit (LSB has highest priority)
    // If no bits are set, output 0
    
    reg [1:0] pos_reg;
    
    always @(*) begin : blk_1
        if (in[0])
            pos_reg = 2'd0;
        else if (in[1])
            pos_reg = 2'd1;
        else if (in[2])
            pos_reg = 2'd2;
        else if (in[3])
            pos_reg = 2'd3;
        else
            pos_reg = 2'd0;  // Default case when input is zero
    end
    
    assign pos = pos_reg;

endmodule
