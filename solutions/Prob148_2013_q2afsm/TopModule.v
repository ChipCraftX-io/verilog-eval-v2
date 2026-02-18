module TopModule (
    input wire clk,
    input wire resetn,
    input wire [2:0] r,
    output wire [2:0] g
);

    // State encoding (one-hot for clarity, can use binary if preferred)
    localparam STATE_A = 2'b00;  // Idle
    localparam STATE_B = 2'b01;  // Grant to device 0
    localparam STATE_C = 2'b10;  // Grant to device 1
    localparam STATE_D = 2'b11;  // Grant to device 2

    // State registers
    reg [1:0] current_state;
    reg [1:0] next_state;

    // State flip-flops with synchronous active-low reset
    always @(posedge clk) begin : blk_1
        if (!resetn) begin
            current_state <= STATE_A;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state reg (combinational)
    always @(*) begin : blk_2
        // Default: stay in current state
        next_state = current_state;
        
        case (current_state)
            STATE_A: begin
                // Priority arbitration: r[0] > r[1] > r[2]
                if (r[0]) begin
                    next_state = STATE_B;
                end else if (r[1]) begin
                    next_state = STATE_C;
                end else if (r[2]) begin
                    next_state = STATE_D;
                end else begin
                    next_state = STATE_A;
                end
            end
            
            STATE_B: begin
                // Stay in B while r[0] is asserted, return to A when released
                if (r[0]) begin
                    next_state = STATE_B;
                end else begin
                    next_state = STATE_A;
                end
            end
            
            STATE_C: begin
                // Stay in C while r[1] is asserted, return to A when released
                if (r[1]) begin
                    next_state = STATE_C;
                end else begin
                    next_state = STATE_A;
                end
            end
            
            STATE_D: begin
                // Stay in D while r[2] is asserted, return to A when released
                if (r[2]) begin
                    next_state = STATE_D;
                end else begin
                    next_state = STATE_A;
                end
            end
            
            default: begin
                next_state = STATE_A;
            end
        endcase
    end

    // Output reg (Moore machine - outputs depend only on current state)
    // g[0] is asserted in state B (device 0 grant)
    // g[1] is asserted in state C (device 1 grant)
    // g[2] is asserted in state D (device 2 grant)
    assign g[0] = (current_state == STATE_B);
    assign g[1] = (current_state == STATE_C);
    assign g[2] = (current_state == STATE_D);

endmodule
