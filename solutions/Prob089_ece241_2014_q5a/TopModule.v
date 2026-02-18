module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding
    localparam COPY   = 1'b0;
    localparam INVERT = 1'b1;
    
    // State register
    reg state;
    
    // Initialize registers
    initial begin : blk_1
        state = COPY;
        z = 0;
    end
    
    // State transition and output reg (sequential)
    always @(posedge clk or posedge areset) begin : blk_2
        if (areset) begin
            state <= COPY;
            z <= 1'b0;
        end else begin
            case (state)
                COPY: begin
                    z <= x;  // Copy the input
                    if (x == 1'b1) begin
                        state <= INVERT;  // After copying first 1, switch to invert
                    end else begin
                        state <= COPY;
                    end
                end
                
                INVERT: begin
                    z <= ~x;  // Invert the input
                    state <= INVERT;  // Stay in invert state
                end
                
                default: begin
                    state <= COPY;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule
