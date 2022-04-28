module left_shift_64_1(x,out);
    input [63:0] x; 
    output [63:0] out; 

    assign out[0] = ~x[63]; 
    assign out[1] = x[0];
    assign out[2] = x[1];
    assign out[3] = x[2];
    assign out[4] = x[3];
    
    assign out[5] = x[4];
    assign out[6] = x[5];
    assign out[7] = x[6];
    assign out[8] = x[7];

    assign out[9] = x[8];
    assign out[10] = x[9];
    assign out[11] = x[10];
    assign out[12] = x[11];

    assign out[13] = x[12];
    assign out[14] = x[13];
    assign out[15] = x[14];
    assign out[16] = x[15];

    assign out[17] = x[16];
    assign out[18] = x[17];
    assign out[19] = x[18];
    assign out[20] = x[19];

    assign out[21] = x[20];
    assign out[22] = x[21];
    assign out[23] = x[22];
    assign out[24] = x[23];

    assign out[25] = x[24];
    assign out[26] = x[25];
    assign out[27] = x[26];
    assign out[28] = x[27];

    assign out[29] = x[28];
    assign out[30] = x[29];
    assign out[31] = x[30];

    assign out[32] = x[31]; 
    assign out[33] = x[32];
    assign out[34] = x[33];
    assign out[35] = x[34];
    assign out[36] = x[35];
    
    assign out[37] = x[36];
    assign out[38] = x[37];
    assign out[39] = x[38];
    assign out[40] = x[39];

    assign out[41] = x[40];
    assign out[42] = x[41];
    assign out[43] = x[42];
    assign out[44] = x[43];

    assign out[45] = x[44];
    assign out[46] = x[45];
    assign out[47] = x[46];
    assign out[48] = x[47];

    assign out[49] = x[48];
    assign out[50] = x[49];
    assign out[51] = x[50];
    assign out[52] = x[51];

    assign out[53] = x[52];
    assign out[54] = x[53];
    assign out[55] = x[54];
    assign out[56] = x[55];

    assign out[57] = x[56];
    assign out[58] = x[57];
    assign out[59] = x[58];
    assign out[60] = x[59];

    assign out[61] = x[60];
    assign out[62] = x[61];
    assign out[63] = x[62];
   
endmodule