module TopModule (
    input wire clk,
    input wire a,
    output reg [2:0] q
);

    initial begin : blk_1
        q = 3'b0;
    end

    always @(posedge clk) begin : blk_2
        if (a) begin
            q <= 3'd4;
        end else begin
            if (q == 3'd6) begin
                q <= 3'd0;
            end else begin
                q <= q + 3'd1;
            end
        end
    end

endmodule
