module TopModule(
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);

    // Method 1: Using assign statement
    assign out_assign = a & b;
    
    // Method 2: Using combinational always block
    always @(*) begin : blk_1
        out_alwaysblock = a & b;
    end

endmodule
