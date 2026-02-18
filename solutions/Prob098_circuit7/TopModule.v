module TopModule (
    input  wire clk,
    input  wire a,
    output reg  q
);

    initial begin : blk_1
        q = 1'bx;
    end

    always @(posedge clk) begin : blk_2
        q <= ~a;
    end

endmodule
