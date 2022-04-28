module and_32(x,y,out);
    input[31:0] x;
    input[31:0] y;
    output[31:0] out;

    and bit_0(out[0], x[0], y[0]); 
    and bit_1(out[1], x[1], y[1]); 
    and bit_2(out[2], x[2], y[2]); 
    and bit_3(out[3], x[3], y[3]); 
    and bit_4(out[4], x[4], y[4]); 

    and bit_5(out[5], x[5], y[5]); 
    and bit_6(out[6], x[6], y[6]); 
    and bit_7(out[7], x[7], y[7]); 
    and bit_8(out[8], x[8], y[8]); 
    and bit_9(out[9], x[9], y[9]); 

    and bit_10(out[10], x[10], y[10]); 
    and bit_11(out[11], x[11], y[11]); 
    and bit_12(out[12], x[12], y[12]); 
    and bit_13(out[13], x[13], y[13]); 
    and bit_14(out[14], x[14], y[14]); 

    and bit_15(out[15], x[15], y[15]); 
    and bit_16(out[16], x[16], y[16]); 
    and bit_17(out[17], x[17], y[17]); 
    and bit_18(out[18], x[18], y[18]); 
    and bit_19(out[19], x[19], y[19]);

    and bit_20(out[20], x[20], y[20]); 
    and bit_21(out[21], x[21], y[21]); 
    and bit_22(out[22], x[22], y[22]); 
    and bit_23(out[23], x[23], y[23]); 
    and bit_24(out[24], x[24], y[24]);

    and bit_25(out[25], x[25], y[25]); 
    and bit_26(out[26], x[26], y[26]); 
    and bit_27(out[27], x[27], y[27]); 
    and bit_28(out[28], x[28], y[28]); 
    and bit_29(out[29], x[29], y[29]);

    and bit_30(out[30], x[30], y[30]); 
    and bit_31(out[31], x[31], y[31]);
    
endmodule