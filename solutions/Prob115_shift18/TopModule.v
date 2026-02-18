module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

    // Initialize output to zero for correct simulation behavior
    initial begin : blk_1
        q = 64'h0;
    end

    always @(posedge clk) begin : blk_2
        if (load) begin
            // Synchronous load has highest priority
            q <= data;
        end else if (ena) begin
            // Shift operations when enabled
            case (amount)
                2'b00: begin
                    // Shift left by 1 bit (logical)
                    q <= {q[62:0], 1'b0};
                end
                
                2'b01: begin
                    // Shift left by 8 bits (logical)
                    q <= {q[55:0], 8'h00};
                end
                
                2'b10: begin
                    // Arithmetic shift right by 1 bit
                    // Sign-extend: replicate MSB (q[63])
                    q <= {q[63], q[63:1]};
                end
                
                2'b11: begin
                    // Arithmetic shift right by 8 bits
                    // Sign-extend: replicate MSB 8 times
                    q <= {{8{q[63]}}, q[63:8]};
                end
            endcase
        end
        // else: hold current value when !load && !ena
    end

endmodule
