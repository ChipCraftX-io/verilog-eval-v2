module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding
    parameter START = 4'd0;
    parameter B0    = 4'd1;
    parameter B1    = 4'd2;
    parameter B2    = 4'd3;
    parameter B3    = 4'd4;
    parameter B4    = 4'd5;
    parameter B5    = 4'd6;
    parameter B6    = 4'd7;
    parameter B7    = 4'd8;
    parameter STOP  = 4'd9;
    parameter DONE  = 4'd10;
    parameter ERR   = 4'd11;

    // State registers
    reg [3:0] state, next;

    // State transition reg (combinational)
    always @(*) begin : blk_1
        case (state)
            START: next = in ? START : B0;
            B0:    next = B1;
            B1:    next = B2;
            B2:    next = B3;
            B3:    next = B4;
            B4:    next = B5;
            B5:    next = B6;
            B6:    next = B7;
            B7:    next = STOP;
            STOP:  next = in ? DONE : ERR;
            DONE:  next = in ? START : B0;
            ERR:   next = in ? START : ERR;
            default: next = START;
        endcase
    end

    // State register (sequential)
    always @(posedge clk) begin : blk_2
        if (reset)
            state <= START;
        else
            state <= next;
    end

    // Output reg
    assign done = (state == DONE);

endmodule
