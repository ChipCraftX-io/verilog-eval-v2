module TopModule(
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);
    // Extract individual BCD digits
    wire [3:0] ones, tens, hundreds, thousands;
    assign ones = q[3:0];
    assign tens = q[7:4];
    assign hundreds = q[11:8];
    assign thousands = q[15:12];
    
    // Generate enable signals (combinational)
    // ena[0]: enable tens digit when ones = 9
    // ena[1]: enable hundreds digit when tens = 9 and ones = 9
    // ena[2]: enable thousands digit when hundreds = 9 and tens = 9 and ones = 9
    always @(*) begin : blk_1
        ena[0] = (ones == 4'd9);
        ena[1] = (tens == 4'd9) && (ones == 4'd9);
        ena[2] = (hundreds == 4'd9) && (tens == 4'd9) && (ones == 4'd9);
    end
    
    // Counter reg (sequential)
    always @(posedge clk) begin : blk_2
        if (reset) begin
            q <= 16'd0;
        end else begin
            // Ones digit always increments
            if (ones == 4'd9) begin
                q[3:0] <= 4'd0;
            end else begin
                q[3:0] <= ones + 4'd1;
            end
            
            // Tens digit increments when ones = 9
            if (ena[0]) begin
                if (tens == 4'd9) begin
                    q[7:4] <= 4'd0;
                end else begin
                    q[7:4] <= tens + 4'd1;
                end
            end
            
            // Hundreds digit increments when tens = 9 and ones = 9
            if (ena[1]) begin
                if (hundreds == 4'd9) begin
                    q[11:8] <= 4'd0;
                end else begin
                    q[11:8] <= hundreds + 4'd1;
                end
            end
            
            // Thousands digit increments when hundreds = 9 and tens = 9 and ones = 9
            if (ena[2]) begin
                if (thousands == 4'd9) begin
                    q[15:12] <= 4'd0;
                end else begin
                    q[15:12] <= thousands + 4'd1;
                end
            end
        end
    end

endmodule
