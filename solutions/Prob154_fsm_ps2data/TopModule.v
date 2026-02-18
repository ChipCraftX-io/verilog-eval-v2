module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  in,
    output reg  [23:0] out_bytes,
    output reg         done
);

    localparam S_IDLE  = 2'd0;
    localparam S_BYTE2 = 2'd1;
    localparam S_BYTE3 = 2'd2;
    localparam S_DONE  = 2'd3;

    reg [1:0] state;
    reg [7:0] byte1, byte2, byte3;

    initial begin : blk_1
        state = S_IDLE;
        done = 1'b0;
        out_bytes = 24'd0;
        byte1 = 8'd0;
        byte2 = 8'd0;
        byte3 = 8'd0;
    end

    always @(posedge clk) begin : blk_2
        if (reset) begin
            state <= S_IDLE;
            done <= 1'b0;
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            byte3 <= 8'd0;
        end else begin
            case (state)
                S_IDLE: begin
                    done <= 1'b0;
                    if (in[3]) begin
                        byte1 <= in;
                        state <= S_BYTE2;
                    end
                end
                S_BYTE2: begin
                    done <= 1'b0;
                    byte2 <= in;
                    state <= S_BYTE3;
                end
                S_BYTE3: begin
                    byte3 <= in;
                    state <= S_DONE;
                    done <= 1'b1;
                    out_bytes <= {byte1, byte2, in};
                end
                S_DONE: begin
                    done <= 1'b0;
                    if (in[3]) begin
                        byte1 <= in;
                        state <= S_BYTE2;
                    end else begin
                        state <= S_IDLE;
                    end
                end
            endcase
        end
    end

endmodule
