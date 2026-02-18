module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    // Initialize output register
    initial begin : blk_1
        q = 100'b0;
    end

    // Synchronous load and rotate reg
    always @(posedge clk) begin : blk_2
        if (load) begin
            // Load has highest priority
            q <= data;
        end else begin
            case (ena)
                2'b01: begin
                    // Rotate right: LSB wraps to MSB
                    // q[99] gets q[0], q[98:0] get q[99:1]
                    q <= {q[0], q[99:1]};
                end
                2'b10: begin
                    // Rotate left: MSB wraps to LSB
                    // q[99:1] get q[98:0], q[0] gets q[99]
                    q <= {q[98:0], q[99]};
                end
                default: begin
                    // 2'b00 and 2'b11: no rotation, hold current value
                    q <= q;
                end
            endcase
        end
    end

endmodule
