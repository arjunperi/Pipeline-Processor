module overflow_checker(A,B, result, overflow);
    input[31:0] A,B, result; 
    output overflow; 
    
    wire msbA; 
    assign msbA = A[31];
    wire msbB; 
    assign msbB = B[31];

    wire msbResult; 
    assign msbResult = result[31]; 

    wire msbA_and_msbB, msbA_and_msbResult; 


    xnor msb_eq(msbA_and_msbB, msbA, msbB); 
    // a- 1,1 = 1; 

    // b- 0,0 = 1; 

    xor res_msb_eq(msbA_and_msbResult, msbA, msbResult); 
    // a- 1,0 = 1;

    // b- 0,1 =1; 

    and (overflow, msbA_and_msbResult, msbA_and_msbB); 
    // a- 1,1 = 1; 

    // b- 1,1 = 1; 


endmodule