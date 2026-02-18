module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire q,
    output wire state
);

    reg state_reg;

    initial begin : blk_1
        state_reg = 1'b0;
    end

    assign state = state_reg;
    assign q = state_reg ^ a ^ b;

    wire next_state;
    assign next_state = state_reg ? (a | b) : (a & b);

    always @(posedge clk) begin : blk_2
        state_reg <= next_state;
    end

endmodule
