module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    always @(*) begin : blk_1
        case (do_sub)
            0: out = a + b;
            1: out = a - b;
        endcase

        // Fixed: Use equality comparison instead of bitwise NOT
        // Also assign both branches to avoid latch inference
        if (out == 8'b0)
            result_is_zero = 1;
        else
            result_is_zero = 0;
    end

endmodule
