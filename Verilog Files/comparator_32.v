module comparator_32(A,B, EQ, GT);
    input[31:0] A, B;
    wire EQprev, GTprev; 
    output EQ,GT; 

    assign EQprev = 1'b1; 
    assign GTprev = 1'b0; 

    wire EQ1, GT1, EQ2, GT2, EQ3, GT3; 

    comparator_8 cascade1(A[31:24], B[31:24], EQprev, GTprev, EQ1, GT1);
    comparator_8 cascade2(A[23:16], B[23:16], EQ1, GT1, EQ2, GT2);
    comparator_8 cascade3(A[15:8], B[15:8], EQ2, GT2, EQ3, GT3);
    comparator_8 cascade4(A[7:0], B[7:0], EQ3, GT3, EQ, GT);

endmodule