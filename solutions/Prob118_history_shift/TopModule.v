module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire        predict_valid,
    input  wire        predict_taken,
    input  wire        train_mispredicted,
    input  wire        train_taken,
    input  wire [31:0] train_history,
    output wire [31:0] predict_history
);

    // 32-wire global history register
    // predict_history[0] = youngest (most recent) branch direction
    // predict_history[31] = oldest branch direction
    reg [31:0] history_reg;
    
    // Output assignment
    assign predict_history = history_reg;
    
    // History register update reg
    always @(posedge clk or posedge areset) begin : blk_1
        if (areset) begin
            // Asynchronous reset - clear history
            history_reg <= 32'h0;
        end
        else begin
            // Priority: misprediction recovery overrides prediction
            if (train_mispredicted) begin
                // Restore history to state after mispredicted branch completes
                // train_history = history before mispredicted branch
                // train_taken = actual outcome of mispredicted branch
                // Result = shift train_history left, insert train_taken at LSB
                history_reg <= {train_history[30:0], train_taken};
            end
            else if (predict_valid) begin
                // Normal prediction - shift in predict_taken from LSB
                // Old history shifts toward MSB, new prediction at wire [0-1:0] history_reg <= {history_reg[30:0], predict_taken};
            end
            // else: hold current value
        end
    end

endmodule
