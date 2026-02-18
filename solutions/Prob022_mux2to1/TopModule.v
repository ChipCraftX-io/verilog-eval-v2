module TopModule (
    input wire a,
    input wire b,
    input wire sel,
    output reg out
);

    // 2-to-1 Multiplexer using case statement
    always @(*) begin : blk_1
        case (sel)
            1'b0: out = a;
            1'b1: out = b;
            default: out = a;  // Default to a for safety
        endcase
    end

endmodule
