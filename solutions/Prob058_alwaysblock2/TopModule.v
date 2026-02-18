module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    // Method 1: Continuous assignment (combinational)
    assign out_assign = a ^ b;

    // Method 2: Combinational always block
    always @(*) begin : blk_1
        out_always_comb = a ^ b;
    end

    // Method 3: Clocked always block (sequential - creates a flip-flop)
    // Initialize output to ensure correct simulation from time 0
    initial begin : blk_2
        out_always_ff = 0;
    end

    always @(posedge clk) begin : blk_3
        out_always_ff <= a ^ b;
    end

endmodule
