// Gshare Branch Predictor — 7-wire PC, 7-wire global history, 128-entry PHT
//
// CRITICAL IMPLEMENTATION DETAILS:
// 1. Async reset (posedge areset in sensitivity list)
// 2. Reset uses BLOCKING assignments (= not <=) for PHT and history
// 3. PHT initialized to 2'b01 (Weakly Not Taken = LNT)
// 4. History update: {history, taken} assigned to 7-wire reg TRUNCATES MSB
//    i.e., {7'b_history, 1'b_taken} = 8 bits → stored in 7-wire reg → drops MSB
//    This is equivalent to: history <= {history[5:0], taken}
// 5. Output gating: predict_taken = X when predict_valid=0
//    predict_history = 7'bxxxxxxx when predict_valid=0
// 6. Priority: if train_mispredicted AND predict_valid in same cycle,
//    train overwrites history (last NBA wins in always block)
// 7. predict sees PHT BEFORE training modifies it (same cycle)

module TopModule (
    input wire clk,
    input wire areset,
    
    input wire predict_valid,
    input wire [6:0] predict_pc,
    output wire predict_taken,
    output wire [6:0] predict_history,
    
    input wire train_valid,
    input wire train_taken,
    input wire train_mispredicted,
    input wire [6:0] train_history,
    input wire [6:0] train_pc
);
  integer i;

    // Pattern History Table — 128 entries of 2-wire saturating counters
    // Counter encoding: 00=SNT, 01=LNT, 10=LT, 11=ST
    reg [1:0] pht [0:127];
    
    // Global branch history register
    reg [6:0] predict_history_r;
    
    // Loop iterator (must be declared before use in Verilog-2001)
    // Compute hash indices
    wire [6:0] predict_index;
    wire [6:0] train_index;
    
    assign predict_index = predict_pc ^ predict_history_r;
    assign train_index = train_pc ^ train_history;
    
    // Prediction outputs (gated by predict_valid)
    assign predict_taken = predict_valid ? pht[predict_index][1] : 1'bx;
    assign predict_history = predict_valid ? predict_history_r : 7'bxxxxxxx;
    
    // Sequential reg — PHT updates, history updates
    always @(posedge clk, posedge areset) begin : blk_1
        if (areset) begin
            // CRITICAL: Use BLOCKING assignments for reset
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] = 2'b01;  // Initialize to LNT (Weakly Not Taken)
            end
            predict_history_r = 7'b0000000;
        end else begin
            // Prediction updates history (predict takes precedence initially)
            if (predict_valid) begin
                // CRITICAL: {7-bit, 1-bit} = 8 bits assigned to 7-wire reg
                // Auto-truncates MSB, equivalent to: {history[5:0], taken}
                predict_history_r <= {predict_history_r, predict_taken};
            end
            
            // Training updates PHT and potentially recovers history
            if (train_valid) begin
                // Update saturating counter at train_index
                if (train_taken) begin
                    // Increment counter (saturate at 11)
                    if (pht[train_index] != 2'b11) begin
                        pht[train_index] <= pht[train_index] + 2'b01;
                    end
                end else begin
                    // Decrement counter (saturate at 00)
                    if (pht[train_index] != 2'b00) begin
                        pht[train_index] <= pht[train_index] - 2'b01;
                    end
                end
                
                // CRITICAL: If mispredicted, recover history
                // This NBA happens AFTER predict's NBA, so it takes precedence
                if (train_mispredicted) begin
                    predict_history_r <= {train_history, train_taken};
                end
            end
        end
    end

endmodule
