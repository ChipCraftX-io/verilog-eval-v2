module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

    // Sum output: XOR of all three inputs
    assign sum = a ^ b ^ cin;
    
    // Carry output: Majority function (at least 2 inputs are 1)
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule
