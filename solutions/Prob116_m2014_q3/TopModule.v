module TopModule(
    input [4:1] x,
    output reg f
);
    // Implement K-map with correct index interpretation
    // K-map headers: x[1]x[2] (columns), x[3]x[4] (rows)
    // x[1] is MSB of column, x[3] is MSB of row
    always @(*) begin : blk_1
        case(x)
            4'b0000: f = 1'bx;  // row=00, col=00: d
            4'b0001: f = 1'bx;  // row=00, col=10: d
            4'b0010: f = 1'b0;  // row=00, col=01: 0
            4'b0011: f = 1'bx;  // row=00, col=11: d
            
            4'b0100: f = 1'b1;  // row=10, col=00: 1
            4'b0101: f = 1'bx;  // row=10, col=10: d
            4'b0110: f = 1'b1;  // row=10, col=01: 1
            4'b0111: f = 1'b0;  // row=10, col=11: 0
            
            4'b1000: f = 1'b0;  // row=01, col=00: 0
            4'b1001: f = 1'b0;  // row=01, col=10: 0
            4'b1010: f = 1'bx;  // row=01, col=01: d
            4'b1011: f = 1'b1;  // row=01, col=11: 1
            
            4'b1100: f = 1'b1;  // row=11, col=00: 1
            4'b1101: f = 1'bx;  // row=11, col=10: d
            4'b1110: f = 1'b1;  // row=11, col=01: 1
            4'b1111: f = 1'bx;  // row=11, col=11: d
            
            default: f = 1'bx;
        endcase
    end

endmodule
