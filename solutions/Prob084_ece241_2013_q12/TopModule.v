//==============================================================================
// Module: TopModule
// Description: 8x1 memory implemented with shift register and multiplexer
//              - Shift register for writing (serial input)
//              - Multiplexer for reading (random access via ABC address)
//==============================================================================

module TopModule (
    input  clk,
    input  enable,
    input  S,
    input  A,
    input  B,
    input  C,
    output Z
);

    //--------------------------------------------------------------------------
    // Internal Signals
    //--------------------------------------------------------------------------
    reg [7:0] Q;  // 8-wire shift register: Q[0] is MSB, Q[7] is LSB
    wire [2:0] addr;  // 3-wire address formed by {A, B, C}
    
    //--------------------------------------------------------------------------
    // Shift Register Logic
    // - Q[0] receives serial input S when enabled
    // - Data shifts from Q[0] -> Q[1] -> ... -> Q[7]
    // - Synchronous enable control
    //--------------------------------------------------------------------------
    always @(posedge clk) begin : blk_1
        if (enable) begin
            Q[7] <= Q[6];
            Q[6] <= Q[5];
            Q[5] <= Q[4];
            Q[4] <= Q[3];
            Q[3] <= Q[2];
            Q[2] <= Q[1];
            Q[1] <= Q[0];
            Q[0] <= S;     // MSB shifted in first
        end
    end
    
    // Initialize shift register to zero
    initial begin : blk_2
        Q = 8'b0;
    end
    
    //--------------------------------------------------------------------------
    // Address Formation
    //--------------------------------------------------------------------------
    assign addr = {A, B, C};
    
    //--------------------------------------------------------------------------
    // 8-to-1 Multiplexer
    // - ABC = 000 -> Z = Q[0]
    // - ABC = 001 -> Z = Q[1]
    // - ABC = 010 -> Z = Q[2]
    // - ABC = 011 -> Z = Q[3]
    // - ABC = 100 -> Z = Q[4]
    // - ABC = 101 -> Z = Q[5]
    // - ABC = 110 -> Z = Q[6]
    // - ABC = 111 -> Z = Q[7]
    //--------------------------------------------------------------------------
    assign Z = (addr == 3'b000) ? Q[0] :
               (addr == 3'b001) ? Q[1] :
               (addr == 3'b010) ? Q[2] :
               (addr == 3'b011) ? Q[3] :
               (addr == 3'b100) ? Q[4] :
               (addr == 3'b101) ? Q[5] :
               (addr == 3'b110) ? Q[6] :
                                  Q[7];

endmodule
