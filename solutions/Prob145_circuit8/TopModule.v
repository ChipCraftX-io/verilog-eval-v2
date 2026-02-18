module TopModule (
    input  wire clock,
    input  wire a,
    output reg  p,
    output reg  q
);

    // p is a positive-level transparent latch
    // When clock=1, p follows a; when clock=0, p holds
    always @(*) begin : blk_1
        if (clock)
            p = a;
    end

    // q is a negative-edge triggered flip-flop sampling p
    initial begin : blk_2
        q = 1'bx;
    end

    always @(negedge clock) begin : blk_3
        q <= p;
    end

endmodule
