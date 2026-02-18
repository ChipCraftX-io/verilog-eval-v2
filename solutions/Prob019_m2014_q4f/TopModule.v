module TopModule(
    input  in1,
    input  in2,
    output out
);

    // AND gate with bubble on in2 input
    // Bubble on input means NOT, so this is: in1 AND (NOT in2)
    assign out = in1 & ~in2;

endmodule
