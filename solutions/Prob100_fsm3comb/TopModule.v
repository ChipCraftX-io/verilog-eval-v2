module TopModule (
    input wire in,
    input wire [1:0] state,
    output reg [1:0] next_state,
    output wire out
);

    // State encoding
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    // Next state reg (combinational)
    always @(*) begin : blk_1
        case (state)
            A: begin
                if (in)
                    next_state = B;
                else
                    next_state = A;
            end
            
            B: begin
                if (in)
                    next_state = B;
                else
                    next_state = C;
            end
            
            C: begin
                if (in)
                    next_state = D;
                else
                    next_state = A;
            end
            
            D: begin
                if (in)
                    next_state = B;
                else
                    next_state = C;
            end
            
            default: begin
                next_state = A;
            end
        endcase
    end

    // Output reg (Moore machine - output depends only on current state)
    assign out = (state == D);

endmodule
