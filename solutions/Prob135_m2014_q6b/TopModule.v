module TopModule(
    input [2:0] y,
    input w,
    output Y1
);
    // Next-state reg for y[1]
    // Y1 = 1 when the next state has wire position 1 set
    // Next states with y[1]=1: B(001), C(010), D(011), F(101)
    // But Y1 specifically is the MIDDLE bit, so:
    // Y1=1 for: C(010) and D(011)
    
    // Transitions to C(010): y[1]=1, y[0]=0
    // - From B(001) when w=0: y==3'b001 && w==0
    // - From F(101) when w=0: y==3'b101 && w==0
    wire to_C = ((y == 3'b001) || (y == 3'b101)) && (w == 1'b0);
    
    // Transitions to D(011): y[1]=1, y[0]=1
    // - From B(001) when w=1: y==3'b001 && w==1
    // - From C(010) when w=1: y==3'b010 && w==1
    // - From E(100) when w=1: y==3'b100 && w==1
    // - From F(101) when w=1: y==3'b101 && w==1
    wire to_D = ((y == 3'b001) || (y == 3'b010) || (y == 3'b100) || (y == 3'b101)) && (w == 1'b1);
    
    // Y1 is set when transitioning to C or D
    assign Y1 = to_C || to_D;

endmodule
