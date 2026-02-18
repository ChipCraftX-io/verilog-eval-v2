module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // BCD digit extraction helpers
    // ss[3:0] = ones, ss[7:4] = tens
    // mm[3:0] = ones, mm[7:4] = tens
    // hh[3:0] = ones, hh[7:4] = tens

    initial begin : blk_1
        pm = 0;
        hh = 8'h12;  // 12 in BCD
        mm = 8'h00;
        ss = 8'h00;
    end

    always @(posedge clk) begin : blk_2
        if (reset) begin
            // Reset to 12:00:00 AM
            pm <= 1'b0;
            hh <= 8'h12;
            mm <= 8'h00;
            ss <= 8'h00;
        end
        else if (ena) begin
            // Increment seconds
            if (ss[3:0] == 4'd9) begin
                // Seconds ones digit rolls over
                ss[3:0] <= 4'd0;
                if (ss[7:4] == 4'd5) begin
                    // Seconds tens digit rolls over (59 -> 00)
                    ss[7:4] <= 4'd0;
                    
                    // Increment minutes
                    if (mm[3:0] == 4'd9) begin
                        // Minutes ones digit rolls over
                        mm[3:0] <= 4'd0;
                        if (mm[7:4] == 4'd5) begin
                            // Minutes tens digit rolls over (59 -> 00)
                            mm[7:4] <= 4'd0;
                            
                            // Increment hours
                            if (hh == 8'h12) begin
                                // 12 -> 01
                                hh <= 8'h01;
                            end
                            else if (hh[3:0] == 4'd9) begin
                                // 09 -> 10
                                hh[3:0] <= 4'd0;
                                hh[7:4] <= 4'd1;
                            end
                            else if (hh == 8'h11) begin
                                // 11 -> 12, toggle AM/PM
                                hh <= 8'h12;
                                pm <= ~pm;
                            end
                            else begin
                                // Normal increment (01->02, 02->03, etc.)
                                hh[3:0] <= hh[3:0] + 4'd1;
                            end
                        end
                        else begin
                            // Increment minutes tens digit
                            mm[7:4] <= mm[7:4] + 4'd1;
                        end
                    end
                    else begin
                        // Increment minutes ones digit
                        mm[3:0] <= mm[3:0] + 4'd1;
                    end
                end
                else begin
                    // Increment seconds tens digit
                    ss[7:4] <= ss[7:4] + 4'd1;
                end
            end
            else begin
                // Increment seconds ones digit
                ss[3:0] <= ss[3:0] + 4'd1;
            end
        end
    end

endmodule
