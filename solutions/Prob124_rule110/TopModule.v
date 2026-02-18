module TopModule (
    input wire clk,
    input wire load,
    input wire [511:0] data,
    output reg [511:0] q
);
  integer i;

    // Initialize output register
    initial begin : blk_1
        q = 512'b0;
    end

    // Rule 110 lookup function
    // Given left, center, right neighbors, return next state
    function automatic rule110;
        input left;
        input center;
        input right;
        begin
            case ({left, center, right})
                3'b111: rule110 = 1'b0;
                3'b110: rule110 = 1'b1;
                3'b101: rule110 = 1'b1;
                3'b100: rule110 = 1'b0;
                3'b011: rule110 = 1'b1;
                3'b010: rule110 = 1'b1;
                3'b001: rule110 = 1'b1;
                3'b000: rule110 = 1'b0;
                default: rule110 = 1'b0;
            endcase
        end
    endfunction

    // Compute next state for all cells
    reg [511:0] next_state;
    always @(*) begin : blk_2
        for (i = 0; i < 512; i = i + 1) begin
            // Determine neighbors with boundary conditions
            // Left neighbor (i+1): 0 if i==511, else q[i+1]
            // Center: q[i]
            // Right neighbor (i-1): 0 if i==0, else q[i-1]
            
            if (i == 0) begin
                // Leftmost cell: left=q[1], center=q[0], right=0
                next_state[i] = rule110(q[1], q[0], 1'b0);
            end else if (i == 511) begin
                // Rightmost cell: left=0, center=q[511], right=q[510]
                next_state[i] = rule110(1'b0, q[511], q[510]);
            end else begin
                // Middle cells: left=q[i+1], center=q[i], right=q[i-1]
                next_state[i] = rule110(q[i+1], q[i], q[i-1]);
            end
        end
    end

    // Sequential reg: load or advance state
    always @(posedge clk) begin : blk_3
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

endmodule
