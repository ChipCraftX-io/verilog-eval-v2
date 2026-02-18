module TopModule (
  input clk,
  input reset,
  input w,
  output z
);

  // One-hot state encoding
  localparam STATE_A = 6'b000001;
  localparam STATE_B = 6'b000010;
  localparam STATE_C = 6'b000100;
  localparam STATE_D = 6'b001000;
  localparam STATE_E = 6'b010000;
  localparam STATE_F = 6'b100000;

  reg [5:0] state, next_state;

  // State register with synchronous reset
  initial begin : blk_1
    state = STATE_A;
  end

  always @(posedge clk) begin : blk_2
    if (reset)
      state <= STATE_A;
    else
      state <= next_state;
  end

  // Next state reg
  always @(*) begin : blk_3
    // Default assignment to prevent latches
    next_state = state;
    
    case (1'b1)  // One-hot case statement
      state[0]: begin  // STATE_A
        if (w)
          next_state = STATE_A;
        else
          next_state = STATE_B;
      end
      
      state[1]: begin  // STATE_B
        if (w)
          next_state = STATE_D;
        else
          next_state = STATE_C;
      end
      
      state[2]: begin  // STATE_C
        if (w)
          next_state = STATE_D;
        else
          next_state = STATE_E;
      end
      
      state[3]: begin  // STATE_D
        if (w)
          next_state = STATE_A;
        else
          next_state = STATE_F;
      end
      
      state[4]: begin  // STATE_E
        if (w)
          next_state = STATE_D;
        else
          next_state = STATE_E;
      end
      
      state[5]: begin  // STATE_F
        if (w)
          next_state = STATE_D;
        else
          next_state = STATE_C;
      end
      
      default: begin
        next_state = STATE_A;
      end
    endcase
  end

  // Moore output reg - combinational
  // z=0 for states A, B, C, D
  // z=1 for states E, F
  assign z = state[4] | state[5];  // E or F

endmodule
