module left_shift_16(x,out);
    input [31:0] x; 
    output [31:0] out; 

    assign out[0] = 0; 
    assign out[1] = 0;
    assign out[2] = 0;
    assign out[3] = 0;
    assign out[4] = 0;
    
    assign out[5] = 0;
    assign out[6] = 0;
    assign out[7] = 0;
    assign out[8] = 0;

    assign out[9] = 0;
    assign out[10] = 0;
    assign out[11] = 0;
    assign out[12] = 0;

    assign out[13] = 0;
    assign out[14] = 0;
    assign out[15] = 0;
    assign out[16] = x[0];

    assign out[17] = x[1];
    assign out[18] = x[2];
    assign out[19] = x[3];
    assign out[20] = x[4];

    assign out[21] = x[5];
    assign out[22] = x[6];
    assign out[23] = x[7];
    assign out[24] = x[8];

    assign out[25] = x[9];
    assign out[26] = x[10];
    assign out[27] = x[11];
    assign out[28] = x[12];

    assign out[29] = x[13];
    assign out[30] = x[14];
    assign out[31] = x[15];
   
endmodule