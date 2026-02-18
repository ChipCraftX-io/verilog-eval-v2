module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

    // Counter to track cycles (need 0-4, so 3 bits sufficient)
    reg [2:0] count;
    
    // Initialize for simulation
    initial begin : blk_1
        count = 3'd0;
    end

    // Sequential reg: counter control
    always @(posedge clk) begin : blk_2
        if (reset) begin
            // Synchronous reset: restart the 4-cycle count
            count <= 3'd0;
        end else begin
            // Count up to 4, then hold
            if (count < 3'd4)
                count <= count + 3'd1;
            // else stay at 4
        end
    end

    // Combinational output: enable during cycles 0-3
    assign shift_ena = (count < 3'd4);

endmodule
