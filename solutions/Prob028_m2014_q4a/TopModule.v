module TopModule (
    input wire d,
    input wire ena,
    output reg q
);

    // D latch: transparent when ena=1, holds when ena=0
    // Use always @(*) combinational block with blocking assignment
    always @(*) begin : blk_1
        if (ena)
            q = d;  // Transparent: output follows input
        // When ena=0, q implicitly holds its value (no else needed)
    end

endmodule
