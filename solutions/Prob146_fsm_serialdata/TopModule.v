module TopModule (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

    // State encoding - MUST match specification exactly
    parameter B0   = 4'd0;
    parameter B1   = 4'd1;
    parameter B2   = 4'd2;
    parameter B3   = 4'd3;
    parameter B4   = 4'd4;
    parameter B5   = 4'd5;
    parameter B6   = 4'd6;
    parameter B7   = 4'd7;
    parameter START = 4'd8;
    parameter STOP  = 4'd9;
    parameter DONE  = 4'd10;
    parameter ERR   = 4'd11;

    // State registers
    reg [3:0] state, next;
    
    // Data byte register (LSB first)
    reg [7:0] data_reg;
    
    // Initialize state and data register
    initial begin : blk_1
        state = START;
        data_reg = 8'b0;
    end

    // Next state reg (combinational)
    always @(*) begin : blk_2
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
    always @(posedge clk) begin : blk_3
        if (reset) begin
            state <= START;
        end else begin
            state <= next;
        end
    end

    // Data capture register (sequential)
    // Capture data bits while in states B0-B7
    always @(posedge clk) begin : blk_4
        if (reset) begin
            data_reg <= 8'b0;
        end else begin
            case (state)
                B0: data_reg[0] <= in;
                B1: data_reg[1] <= in;
                B2: data_reg[2] <= in;
                B3: data_reg[3] <= in;
                B4: data_reg[4] <= in;
                B5: data_reg[5] <= in;
                B6: data_reg[6] <= in;
                B7: data_reg[7] <= in;
                default: data_reg <= data_reg;
            endcase
        end
    end

    // Output assignments (Moore outputs - combinational)
    assign done = (state == DONE);
    assign out_byte = data_reg;

endmodule
