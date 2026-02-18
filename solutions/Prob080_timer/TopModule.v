module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);
    // Internal 10-wire counter register
    reg [9:0] count;
    
    // Initialize counter to zero
    initial begin : blk_1
        count = 10'd0;
    end
    
    // Sequential reg: load or decrement counter
    always @(posedge clk) begin : blk_2
        if (load) begin
            // Priority: load new value
            count <= data;
        end else if (count != 10'd0) begin
            // Decrement only if not at zero
            count <= count - 10'd1;
        end
        // else: count stays at 0
    end
    
    // Combinational output: terminal count asserted when counter is 0
    assign tc = (count == 10'd0);

endmodule
