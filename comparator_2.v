module comparator_2(A,B,EQprev,GTprev,EQ,GT);
    input [1:0] A,B;
    input EQprev, GTprev; 
    output EQ,GT; 
    wire [2:0] select;
    wire B0_not, equal, greater, greater_1, greater_2; 
    
    assign select [2:1] = A; 
    assign select[0] = B[1]; 

    not b0_inv(B0_not, B[0]);

    mux_8 eq(equal, select, B0_not, 0, B[0], 0, 0, B0_not, 0, B[0]);
    mux_8 gt(greater, select, 0,0, B0_not, 0,1,0,1, B0_not); 

    and equal_result(EQ, equal, EQprev, ~GTprev); 

    and greater_poss_1(greater_1, greater, EQprev, ~GTprev); 
    and greater_poss_2(greater_2, ~EQprev, GTprev); 
    or greater_result(GT, greater_1, greater_2); 
endmodule