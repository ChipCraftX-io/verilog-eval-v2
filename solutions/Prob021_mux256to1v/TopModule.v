module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output reg  [3:0]    out
);

    // 256-to-1 mux, 4 bits wide
    // Each 4-wire input is packed sequentially in the 1024-wire input vector
    // sel=0 -> in[3:0], sel=1 -> in[7:4], etc.
    
    always @(*) begin : blk_1
        // Indexed part-select: extract 4 bits starting at (sel*4)
        // The +: syntax means "starting at base, width of 4 bits ascending"
        out = in[sel*4 +: 4];
    end

endmodule
