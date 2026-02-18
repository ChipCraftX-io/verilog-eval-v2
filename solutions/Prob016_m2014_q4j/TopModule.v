module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [4:0] c;  // carry chain: c[0] is cin, c[4] is cout
    wire [3:0] s;  // intermediate sum bits
    
    // Instantiate full adders for each wire position
    full_adder fa0(.a(x[0]), .b(y[0]), .cin(1'b0),    .sum(s[0]), .cout(c[1]));
    full_adder fa1(.a(x[1]), .b(y[1]), .cin(c[1]),    .sum(s[1]), .cout(c[2]));
    full_adder fa2(.a(x[2]), .b(y[2]), .cin(c[2]),    .sum(s[2]), .cout(c[3]));
    full_adder fa3(.a(x[3]), .b(y[3]), .cin(c[3]),    .sum(s[3]), .cout(c[4]));
    
    // Output: 4-wire sum + overflow (carry out)
    assign sum = {c[4], s[3:0]};
    
endmodule
