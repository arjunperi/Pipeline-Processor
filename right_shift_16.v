module right_shift_16(x,out);
    input [31:0] x; 
    output [31:0] out; 

    assign out[0] = x[16]; 
    assign out[1] = x[17];
    assign out[2] = x[18];
    assign out[3] = x[19];
    assign out[4] = x[20];
    
    assign out[5] = x[21];
    assign out[6] = x[22];
    assign out[7] = x[23];
    assign out[8] = x[24];

    assign out[9] = x[25];
    assign out[10] = x[26];
    assign out[11] = x[27];
    assign out[12] = x[28];

    assign out[13] = x[29];
    assign out[14] = x[30];
    assign out[15] = x[31];
    assign out[16] = x[31];

    assign out[17] = x[31];
    assign out[18] = x[31];
    assign out[19] = x[31];
    assign out[20] = x[31];

    assign out[21] = x[31];
    assign out[22] = x[31];
    assign out[23] = x[31];
    assign out[24] = x[31];

    assign out[25] = x[31];
    assign out[26] = x[31];
    assign out[27] = x[31];
    assign out[28] = x[31];

    assign out[29] = x[31];
    assign out[30] = x[31];
    assign out[31] = x[31];
   
endmodule