module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    // Intermediate comparison results
    reg [7:0] min_ab;
    reg [7:0] min_cd;
    reg [7:0] min_final;
    
    // Find minimum using cascaded comparisons
    always @(*) begin : blk_1
        // Compare first pair
        if (a < b)
            min_ab = a;
        else
            min_ab = b;
            
        // Compare second pair
        if (c < d)
            min_cd = c;
        else
            min_cd = d;
            
        // Compare the two minimums
        if (min_ab < min_cd)
            min_final = min_ab;
        else
            min_final = min_cd;
    end
    
    assign min = min_final;

endmodule
