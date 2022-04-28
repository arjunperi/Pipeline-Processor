module or_32(x,y,out);
    input [31:0] x;
    input [31:0] y;
    output [31:0] out;

    or bit_0(out[0], x[0], y[0]); 
    or bit_1(out[1], x[1], y[1]); 
    or bit_2(out[2], x[2], y[2]); 
    or bit_3(out[3], x[3], y[3]); 
    or bit_4(out[4], x[4], y[4]); 

    or bit_5(out[5], x[5], y[5]); 
    or bit_6(out[6], x[6], y[6]); 
    or bit_7(out[7], x[7], y[7]); 
    or bit_8(out[8], x[8], y[8]); 
    or bit_9(out[9], x[9], y[9]); 

    or bit_10(out[10], x[10], y[10]); 
    or bit_11(out[11], x[11], y[11]); 
    or bit_12(out[12], x[12], y[12]); 
    or bit_13(out[13], x[13], y[13]); 
    or bit_14(out[14], x[14], y[14]); 

    or bit_15(out[15], x[15], y[15]); 
    or bit_16(out[16], x[16], y[16]); 
    or bit_17(out[17], x[17], y[17]); 
    or bit_18(out[18], x[18], y[18]); 
    or bit_19(out[19], x[19], y[19]);

    or bit_20(out[20], x[20], y[20]); 
    or bit_21(out[21], x[21], y[21]); 
    or bit_22(out[22], x[22], y[22]); 
    or bit_23(out[23], x[23], y[23]); 
    or bit_24(out[24], x[24], y[24]);

    or bit_25(out[25], x[25], y[25]); 
    or bit_26(out[26], x[26], y[26]); 
    or bit_27(out[27], x[27], y[27]); 
    or bit_28(out[28], x[28], y[28]); 
    or bit_29(out[29], x[29], y[29]);

    or bit_30(out[30], x[30], y[30]); 
    or bit_31(out[31], x[31], y[31]);
    

endmodule