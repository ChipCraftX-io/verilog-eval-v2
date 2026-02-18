module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

    // State encoding (one-hot)
    localparam S    = 10'b0000000001;
    localparam S1   = 10'b0000000010;
    localparam S11  = 10'b0000000100;
    localparam S110 = 10'b0000001000;
    localparam B0   = 10'b0000010000;
    localparam B1   = 10'b0000100000;
    localparam B2   = 10'b0001000000;
    localparam B3   = 10'b0010000000;
    localparam CNT  = 10'b0100000000;
    localparam WAIT = 10'b1000000000;

    // State registers
    reg [9:0] state, next_state;

    // Counters
    reg [9:0] fcount;      // Fast counter: 0-999
    reg [3:0] scount;      // Slow counter: delay value and countdown

    // Control signals
    wire shift_ena;
    wire done_counting;

    // Initialize state
    initial begin : blk_1
        state = S;
        fcount = 10'd0;
        scount = 4'd0;
    end

    // State register
    always @(posedge clk) begin : blk_2
        if (reset)
            state <= S;
        else
            state <= next_state;
    end

    // Next state reg
    always @(*) begin : blk_3
        next_state = state; // Default: stay in current state
        
        case (1'b1) // synthesis parallel_case full_case
            state[0]: begin // S
                if (data)
                    next_state = S1;
                else
                    next_state = S;
            end
            
            state[1]: begin // S1
                if (data)
                    next_state = S11;
                else
                    next_state = S;
            end
            
            state[2]: begin // S11
                if (data)
                    next_state = S11;  // Stay on consecutive 1s
                else
                    next_state = S110;
            end
            
            state[3]: begin // S110
                if (data)
                    next_state = B0;   // 1101 complete
                else
                    next_state = S;
            end
            
            state[4]: begin // B0
                next_state = B1;
            end
            
            state[5]: begin // B1
                next_state = B2;
            end
            
            state[6]: begin // B2
                next_state = B3;
            end
            
            state[7]: begin // B3
                next_state = CNT;
            end
            
            state[8]: begin // CNT
                if (done_counting)
                    next_state = WAIT;
                else
                    next_state = CNT;
            end
            
            state[9]: begin // WAIT
                if (ack)
                    next_state = S;
                else
                    next_state = WAIT;
            end
            
            default: next_state = S;
        endcase
    end

    // Shift enable signal
    assign shift_ena = state[4] | state[5] | state[6] | state[7]; // B0, B1, B2, B3

    // Shift register for delay value (MSB first)
    always @(posedge clk) begin : blk_4
        if (reset)
            scount <= 4'd0;
        else if (shift_ena)
            scount <= {scount[2:0], data};
        else if (counting && fcount == 10'd999 && scount != 4'd0)
            scount <= scount - 4'd1;
    end

    // Fast counter (0-999)
    always @(posedge clk) begin : blk_5
        if (reset)
            fcount <= 10'd0;
        else if (!counting)
            fcount <= 10'd0;
        else if (fcount == 10'd999)
            fcount <= 10'd0;
        else
            fcount <= fcount + 10'd1;
    end

    // Done counting condition
    assign done_counting = (scount == 4'd0) && (fcount == 10'd999);

    // Output assignments (combinational)
    assign counting = state[8]; // CNT state
    assign done = state[9];     // WAIT state
    assign count = counting ? scount : 4'bxxxx;

endmodule
