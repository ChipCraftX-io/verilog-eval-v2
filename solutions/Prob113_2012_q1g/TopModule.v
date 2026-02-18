module TopModule(
    input [3:0] x,
    output reg f
);

    // K-map indexing: x[0]x[1] for columns (x[0] is MSB), x[2]x[3] for rows (x[2] is MSB)
    // x[3:0] = {x[3], x[2], x[1], x[0]}
    // Gray code ordering: 00, 01, 11, 10
    
    always @(*) begin : blk_1
        case(x)
            // Row x[2]x[3]=00, Col x[0]x[1]=00: x={0,0,0,0}
            4'b0000: f = 1'b1;
            // Row x[2]x[3]=00, Col x[0]x[1]=01: x={0,0,1,0}
            4'b0010: f = 1'b0;
            // Row x[2]x[3]=00, Col x[0]x[1]=11: x={0,0,1,1}
            4'b0011: f = 1'b0;
            // Row x[2]x[3]=00, Col x[0]x[1]=10: x={0,0,0,1}
            4'b0001: f = 1'b1;
            
            // Row x[2]x[3]=01, Col x[0]x[1]=00: x={1,0,0,0}
            4'b1000: f = 1'b0;
            // Row x[2]x[3]=01, Col x[0]x[1]=01: x={1,0,1,0}
            4'b1010: f = 1'b0;
            // Row x[2]x[3]=01, Col x[0]x[1]=11: x={1,0,1,1}
            4'b1011: f = 1'b0;
            // Row x[2]x[3]=01, Col x[0]x[1]=10: x={1,0,0,1}
            4'b1001: f = 1'b0;
            
            // Row x[2]x[3]=11, Col x[0]x[1]=00: x={1,1,0,0}
            4'b1100: f = 1'b1;
            // Row x[2]x[3]=11, Col x[0]x[1]=01: x={1,1,1,0}
            4'b1110: f = 1'b1;
            // Row x[2]x[3]=11, Col x[0]x[1]=11: x={1,1,1,1}
            4'b1111: f = 1'b1;
            // Row x[2]x[3]=11, Col x[0]x[1]=10: x={1,1,0,1}
            4'b1101: f = 1'b0;
            
            // Row x[2]x[3]=10, Col x[0]x[1]=00: x={0,1,0,0}
            4'b0100: f = 1'b1;
            // Row x[2]x[3]=10, Col x[0]x[1]=01: x={0,1,1,0}
            4'b0110: f = 1'b1;
            // Row x[2]x[3]=10, Col x[0]x[1]=11: x={0,1,1,1}
            4'b0111: f = 1'b0;
            // Row x[2]x[3]=10, Col x[0]x[1]=10: x={0,1,0,1}
            4'b0101: f = 1'b1;
            
            default: f = 1'b0;
        endcase
    end

endmodule
