module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state wires
    wire [2:0] Y;
    
    // Y[2] = 1 when next state is 100
    // Sources: (y=001 and x=1) or (y=100 and x=1)
    assign Y[2] = (y == 3'b001 && x == 1'b1) || 
                  (y == 3'b100 && x == 1'b1);
    
    // Y[1] = 1 when next state is 010 or 011
    // Sources: (y=010 and x=0) or (y=011 and x=1) or (y=100 and x=0)
    assign Y[1] = (y == 3'b010 && x == 1'b0) || 
                  (y == 3'b011 && x == 1'b1) || 
                  (y == 3'b100 && x == 1'b0);
    
    // Y[0] = 1 when next state is 001 or 011
    // Sources: (y=000 and x=1) or (y=001 and x=0) or (y=010 and x=1) or (y=011 and x=0) or (y=100 and x=0)
    assign Y[0] = (y == 3'b000 && x == 1'b1) || 
                  (y == 3'b001 && x == 1'b0) || 
                  (y == 3'b010 && x == 1'b1) || 
                  (y == 3'b011 && x == 1'b0) ||
                  (y == 3'b100 && x == 1'b0);
    
    // Output Y0 is the LSB of next state
    assign Y0 = Y[0];
    
    // Output z = 1 when current state is 011 or 100
    assign z = (y == 3'b011) || (y == 3'b100);

endmodule
