module TopModule (
    input wire clk,
    input wire load,
    input wire [255:0] data,
    output reg [255:0] q
);
  integer col, dc, dr, i, n_col, n_idx, n_row, row;

    // Initialize output to zero
    initial begin : blk_1
        q = 256'b0;
    end

    // Internal signals for next state calculation
    reg [255:0] q_next;
    
    // Neighbor count for each cell
    reg [3:0] neighbor_count [0:255];
    
    // Iterator variable
    // Combinational reg to calculate next state
    always @(*) begin : blk_2
        // Calculate neighbor count for each cell
        for (i = 0; i < 256; i = i + 1) begin
            row = i / 16;
            col = i % 16;
            neighbor_count[i] = 4'b0;
            
            // Check all 8 neighbors with toroidal wrap-around
            for (dr = -1; dr <= 1; dr = dr + 1) begin
                for (dc = -1; dc <= 1; dc = dc + 1) begin
                    // Skip the cell itself
                    if (dr != 0 || dc != 0) begin
                        // Calculate neighbor position with wrap-around
                        n_row = (row + dr + 16) % 16;
                        n_col = (col + dc + 16) % 16;
                        n_idx = n_row * 16 + n_col;
                        
                        // Add to neighbor count if neighbor is alive
                        neighbor_count[i] = neighbor_count[i] + q[n_idx];
                    end
                end
            end
        end
        
        // Calculate next state based on neighbor count
        for (i = 0; i < 256; i = i + 1) begin
            case (neighbor_count[i])
                4'd0, 4'd1: q_next[i] = 1'b0;           // 0-1 neighbors: die
                4'd2:       q_next[i] = q[i];           // 2 neighbors: stay same
                4'd3:       q_next[i] = 1'b1;           // 3 neighbors: alive
                default:    q_next[i] = 1'b0;           // 4+ neighbors: die
            endcase
        end
    end
    
    // Sequential reg to update state
    always @(posedge clk) begin : blk_3
        if (load) begin
            q <= data;
        end else begin
            q <= q_next;
        end
    end

endmodule
