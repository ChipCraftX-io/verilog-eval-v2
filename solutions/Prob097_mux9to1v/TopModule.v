module TopModule (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire [15:0] c,
    input wire [15:0] d,
    input wire [15:0] e,
    input wire [15:0] f,
    input wire [15:0] g,
    input wire [15:0] h,
    input wire [15:0] i,
    input wire [3:0] sel,
    output reg [15:0] out
);

    // 9-to-1 multiplexer with 16-wire width
    // sel=0 to 8 select inputs a through i
    // sel=9 to 15 output all 1's
    always @(*) begin : blk_1
        case (sel)
            4'd0:    out = a;
            4'd1:    out = b;
            4'd2:    out = c;
            4'd3:    out = d;
            4'd4:    out = e;
            4'd5:    out = f;
            4'd6:    out = g;
            4'd7:    out = h;
            4'd8:    out = i;
            default: out = 16'hFFFF;  // sel=9 to 15: all bits set to 1
        endcase
    end

endmodule
