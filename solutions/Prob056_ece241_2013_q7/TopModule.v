module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);
    // Initialize output to known state
    initial begin : blk_1
        Q = 1'b0;
    end
    
    // JK flip-flop behavior on positive clock edge
    always @(posedge clk) begin : blk_2
        case ({j, k})
            2'b00: Q <= Q;        // Hold: Q = Qold
            2'b01: Q <= 1'b0;     // Reset: Q = 0
            2'b10: Q <= 1'b1;     // Set: Q = 1
            2'b11: Q <= ~Q;       // Toggle: Q = ~Qold
        endcase
    end

endmodule
