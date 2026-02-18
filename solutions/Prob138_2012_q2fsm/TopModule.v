module TopModule (
    input wire clk,
    input wire reset,
    input wire w,
    output wire z
);

    // State encoding (3 bits for 6 states)
    localparam [2:0] A = 3'b000;
    localparam [2:0] B = 3'b001;
    localparam [2:0] C = 3'b010;
    localparam [2:0] D = 3'b011;
    localparam [2:0] E = 3'b100;
    localparam [2:0] F = 3'b101;

    // State registers
    reg [2:0] state, next_state;

    // State register (sequential reg)
    always @(posedge clk) begin : blk_1
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state reg (combinational)
    always @(*) begin : blk_2
        case (state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A;  // Safe default
        endcase
    end

    // Moore output (combinational - depends only on state)
    // z = 1 when in state E or F, otherwise 0
    assign z = (state == E) || (state == F);

endmodule
