module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

    // Initialize output to zero for correct simulation behavior
    initial begin : blk_1
        q = 16'h0000;
    end

    // Synchronous active-low reset with byte-enable control
    always @(posedge clk) begin : blk_2
        if (!resetn) begin
            // Active-low reset: clear all flip-flops
            q <= 16'h0000;
        end
        else begin
            // Byte-enable control for lower byte [7:0]
            if (byteena[0]) begin
                q[7:0] <= d[7:0];
            end
            
            // Byte-enable control for upper byte [15:8]
            if (byteena[1]) begin
                q[15:8] <= d[15:8];
            end
        end
    end

endmodule
