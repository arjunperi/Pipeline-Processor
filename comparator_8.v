module comparator_8(A,B,EQprev,GTprev, EQ,GT);
    input[7:0] A, B;
    input EQprev, GTprev; 
    output EQ,GT; 

    wire EQ1, GT1, EQ2, GT2, EQ3, GT3; 

    comparator_2 cascade1(A[7:6], B[7:6], EQprev, GTprev, EQ1, GT1);
    comparator_2 cascade2(A[5:4], B[5:4], EQ1, GT1, EQ2, GT2);
    comparator_2 cascade3(A[3:2], B[3:2], EQ2, GT2, EQ3, GT3);
    comparator_2 cascade4(A[1:0], B[1:0], EQ3, GT3, EQ, GT);
endmodule