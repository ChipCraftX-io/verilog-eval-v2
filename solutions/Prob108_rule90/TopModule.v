module TopModule (
    input wire clk,
    input wire load,
    input wire [511:0] data,
    output reg [511:0] q
);

    // Initialize output register to zero
    initial begin : blk_1
        q = 512'b0;
    end

    // Temporary wire to hold next state calculation
    wire [511:0] next_q;
    
    // Compute next state for each cell according to Rule 90
    // Rule 90: next_state = left_neighbor XOR right_neighbor
    // (Note: The center cell itself is NOT used in Rule 90)
    
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule90_cells
            if (i == 0) begin
                // Leftmost cell: left neighbor is 0 (boundary condition)
                assign next_q[i] = 1'b0 ^ q[i+1];
            end
            else if (i == 511) begin
                // Rightmost cell: right neighbor is 0 (boundary condition)
                assign next_q[i] = q[i-1] ^ 1'b0;
            end
            else begin
                // Interior cells: XOR of left and right neighbors
                assign next_q[i] = q[i-1] ^ q[i+1];
            end
        end
    endgenerate
    
    // Sequential reg: update state on positive clock edge
    always @(posedge clk) begin : blk_2
        if (load) begin
            // Load new initial state from data input
            q <= data;
        end
        else begin
            // Advance to next generation according to Rule 90
            q <= next_q;
        end
    end

endmodule
