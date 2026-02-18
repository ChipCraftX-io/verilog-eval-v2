module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

    reg [1:0] counter;
    
    // Asynchronous reset, positive edge clock
    always @(posedge clk or posedge areset) begin : blk_1
        if (areset) begin
            counter <= 2'b01;  // Reset to weakly not-taken
        end else begin
            if (train_valid) begin
                if (train_taken) begin
                    // Increment with saturation at 3
                    if (counter != 2'b11)
                        counter <= counter + 2'b01;
                end else begin
                    // Decrement with saturation at 0
                    if (counter != 2'b00)
                        counter <= counter - 2'b01;
                end
            end
            // else: train_valid = 0, counter holds its value (implicit)
        end
    end
    
    // Output the counter value
    assign state = counter;

endmodule
