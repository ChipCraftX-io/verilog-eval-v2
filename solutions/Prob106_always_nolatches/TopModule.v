module TopModule(
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

    // Combinational reg to decode PS/2 scancodes for arrow keys
    // Uses case statement for clear, synthesizable mapping
    always @(*) begin : blk_1
        // Default: no arrow key pressed
        left  = 1'b0;
        down  = 1'b0;
        right = 1'b0;
        up    = 1'b0;
        
        // Decode scancode to arrow key output
        case (scancode)
            16'he06b: left  = 1'b1;  // Left arrow
            16'he072: down  = 1'b1;  // Down arrow
            16'he074: right = 1'b1;  // Right arrow
            16'he075: up    = 1'b1;  // Up arrow
            default: begin
                // All outputs remain 0 (already set above)
                left  = 1'b0;
                down  = 1'b0;
                right = 1'b0;
                up    = 1'b0;
            end
        endcase
    end

endmodule
