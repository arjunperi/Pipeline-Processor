module regfile1 (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg, buttonPressed,
	data_readRegA, data_readRegB, reg1Val
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;
    input [31:0] buttonPressed;


	output [31:0] data_readRegA, data_readRegB, reg1Val;
    
    // wire clock;
    // not (clock1, clock);

    // add your code here

    wire [31:0] decoder_select;

    wire and0,and1,and2,and3,and4,and5,and6,and7,and8,and9,and10,and11,and12,and13,and14,and15,and16,and17,and18,and19,and20,and21,and22,and23,and24,and25,and26,and27,and28,and29,and30,and31;

    wire[31:0] ro0,ro1,ro2,ro3,ro4,ro5,ro6,ro7,ro8,ro9,ro10,ro11,ro12,ro13,ro14,ro15,ro16,ro17,ro18,ro19,ro20,ro21,ro22,ro23,ro24,ro25,ro26,ro27,ro28,ro29,ro30,ro31;

    wire [31:0] ao, bo; 
    


    //output of top decoder
    decoder_32 dselect(decoder_select, ctrl_writeReg, 1'b1); 


    //output of and gates
    and a0(and0, decoder_select[0], ctrl_writeEnable);
    and a1(and1, decoder_select[1], ctrl_writeEnable);
    and a2(and2, decoder_select[2], ctrl_writeEnable);
    and a3(and3, decoder_select[3], ctrl_writeEnable);
    and a4(and4, decoder_select[4], ctrl_writeEnable);
    and a5(and5, decoder_select[5], ctrl_writeEnable);
    and a6(and6, decoder_select[6], ctrl_writeEnable);
    and a7(and7, decoder_select[7], ctrl_writeEnable);
    and a8(and8, decoder_select[8], ctrl_writeEnable);
    and a9(and9, decoder_select[9], ctrl_writeEnable);
    and a10(and10, decoder_select[10], ctrl_writeEnable);
    and a11(and11, decoder_select[11], ctrl_writeEnable);
    and a12(and12, decoder_select[12], ctrl_writeEnable);
    and a13(and13, decoder_select[13], ctrl_writeEnable);
    and a14(and14, decoder_select[14], ctrl_writeEnable);
    and a15(and15, decoder_select[15], ctrl_writeEnable);
    and a16(and16, decoder_select[16], ctrl_writeEnable);
    and a17(and17, decoder_select[17], ctrl_writeEnable);
    and a18(and18, decoder_select[18], ctrl_writeEnable);
    and a19(and19, decoder_select[19], ctrl_writeEnable);
    and a20(and20, decoder_select[20], ctrl_writeEnable);
    and a21(and21, decoder_select[21], ctrl_writeEnable);
    and a22(and22, decoder_select[22], ctrl_writeEnable);
    and a23(and23, decoder_select[23], ctrl_writeEnable);
    and a24(and24, decoder_select[24], ctrl_writeEnable);
    and a25(and25, decoder_select[25], ctrl_writeEnable);
    and a26(and26, decoder_select[26], ctrl_writeEnable);
    and a27(and27, decoder_select[27], ctrl_writeEnable);
    and a28(and28, decoder_select[28], ctrl_writeEnable);
    and a29(and29, decoder_select[29], ctrl_writeEnable);
    and a30(and30, decoder_select[30], ctrl_writeEnable);
    and a31(and31, decoder_select[31], ctrl_writeEnable);

    //output of registers
    assign ro0 = 32'b0; 

    register_32 o1(ro1, data_writeReg, clock, and1, ctrl_reset);
    //need this output
    assign reg1Val = ro1; 
    register_32 o2(ro2, data_writeReg, clock, and2, ctrl_reset);
    //r3 is going to be the buttonPress register, either 1 or 0
    register_32 o3(ro3, buttonPressed, clock, 1'b1, ctrl_reset);
    register_32 o4(ro4, data_writeReg, clock, and4, ctrl_reset);
    register_32 o5(ro5, data_writeReg, clock, and5, ctrl_reset);
    register_32 o6(ro6, data_writeReg, clock, and6, ctrl_reset);
    register_32 o7(ro7, data_writeReg, clock, and7, ctrl_reset);
    register_32 o8(ro8, data_writeReg, clock, and8, ctrl_reset);
    register_32 o9(ro9, data_writeReg, clock, and9, ctrl_reset);
    register_32 o10(ro10, data_writeReg, clock, and10, ctrl_reset);
    register_32 o11(ro11, data_writeReg, clock, and11, ctrl_reset);
    register_32 o12(ro12, data_writeReg, clock, and12, ctrl_reset);
    register_32 o13(ro13, data_writeReg, clock, and13, ctrl_reset);
    register_32 o14(ro14, data_writeReg, clock, and14, ctrl_reset);
    register_32 o15(ro15, data_writeReg, clock, and15, ctrl_reset);
    register_32 o16(ro16, data_writeReg, clock, and16, ctrl_reset);
    register_32 o17(ro17, data_writeReg, clock, and17, ctrl_reset);
    register_32 o18(ro18, data_writeReg, clock, and18, ctrl_reset);
    register_32 o19(ro19, data_writeReg, clock, and19, ctrl_reset);
    register_32 o20(ro20, data_writeReg, clock, and20, ctrl_reset);
    register_32 o21(ro21, data_writeReg, clock, and21, ctrl_reset);
    register_32 o22(ro22, data_writeReg, clock, and22, ctrl_reset);
    register_32 o23(ro23, data_writeReg, clock, and23, ctrl_reset);
    register_32 o24(ro24, data_writeReg, clock, and24, ctrl_reset);
    register_32 o25(ro25, data_writeReg, clock, and25, ctrl_reset);
    register_32 o26(ro26, data_writeReg, clock, and26, ctrl_reset);
    register_32 o27(ro27, data_writeReg, clock, and27, ctrl_reset);
    register_32 o28(ro28, data_writeReg, clock, and28, ctrl_reset);
    register_32 o29(ro29, data_writeReg, clock, and29, ctrl_reset);
    register_32 o30(ro30, data_writeReg, clock, and30, ctrl_reset);
    register_32 o31(ro31, data_writeReg, clock, and31, ctrl_reset);


    //output of A decoder
    decoder_32 aout(ao, ctrl_readRegA, 1'b1); 

    //output of B decoder
    decoder_32 bout(bo, ctrl_readRegB, 1'b1); 

    //output of A tri states
    tri_state tsa0(ro0, ao[0], data_readRegA);
    tri_state tsa1(ro1, ao[1], data_readRegA);
    tri_state tsa2(ro2, ao[2], data_readRegA);
    tri_state tsa3(ro3, ao[3], data_readRegA);
    tri_state tsa4(ro4, ao[4], data_readRegA);
    tri_state tsa5(ro5, ao[5], data_readRegA);
    tri_state tsa6(ro6, ao[6], data_readRegA);
    tri_state tsa7(ro7, ao[7], data_readRegA);
    tri_state tsa8(ro8, ao[8], data_readRegA);
    tri_state tsa9(ro9, ao[9], data_readRegA);
    tri_state tsa10(ro10, ao[10], data_readRegA);
    tri_state tsa11(ro11, ao[11], data_readRegA);
    tri_state tsa12(ro12, ao[12], data_readRegA);
    tri_state tsa13(ro13, ao[13], data_readRegA);
    tri_state tsa14(ro14, ao[14], data_readRegA);
    tri_state tsa15(ro15, ao[15], data_readRegA);
    tri_state tsa16(ro16, ao[16], data_readRegA);
    tri_state tsa17(ro17, ao[17], data_readRegA);
    tri_state tsa18(ro18, ao[18], data_readRegA);
    tri_state tsa19(ro19, ao[19], data_readRegA);
    tri_state tsa20(ro20, ao[20], data_readRegA);
    tri_state tsa21(ro21, ao[21], data_readRegA);
    tri_state tsa22(ro22, ao[22], data_readRegA);
    tri_state tsa23(ro23, ao[23], data_readRegA);
    tri_state tsa24(ro24, ao[24], data_readRegA);
    tri_state tsa25(ro25, ao[25], data_readRegA);
    tri_state tsa26(ro26, ao[26], data_readRegA);
    tri_state tsa27(ro27, ao[27], data_readRegA);
    tri_state tsa28(ro28, ao[28], data_readRegA);
    tri_state tsa29(ro29, ao[29], data_readRegA);
    tri_state tsa30(ro30, ao[30], data_readRegA);
    tri_state tsa31(ro31, ao[31], data_readRegA);

    //output of B tri states
    tri_state tsb0(ro0, bo[0], data_readRegB);
    tri_state tsb1(ro1, bo[1], data_readRegB);
    tri_state tsb2(ro2, bo[2], data_readRegB);
    tri_state tsb3(ro3, bo[3], data_readRegB);
    tri_state tsb4(ro4, bo[4], data_readRegB);
    tri_state tsb5(ro5, bo[5], data_readRegB);
    tri_state tsb6(ro6, bo[6], data_readRegB);
    tri_state tsb7(ro7, bo[7], data_readRegB);
    tri_state tsb8(ro8, bo[8], data_readRegB);
    tri_state tsb9(ro9, bo[9], data_readRegB);
    tri_state tsb10(ro10, bo[10], data_readRegB);
    tri_state tsb11(ro11, bo[11], data_readRegB);
    tri_state tsb12(ro12, bo[12], data_readRegB);
    tri_state tsb13(ro13, bo[13], data_readRegB);
    tri_state tsb14(ro14, bo[14], data_readRegB);
    tri_state tsb15(ro15, bo[15], data_readRegB);
    tri_state tsb16(ro16, bo[16], data_readRegB);
    tri_state tsb17(ro17, bo[17], data_readRegB);
    tri_state tsb18(ro18, bo[18], data_readRegB);
    tri_state tsb19(ro19, bo[19], data_readRegB);
    tri_state tsb20(ro20, bo[20], data_readRegB);
    tri_state tsb21(ro21, bo[21], data_readRegB);
    tri_state tsb22(ro22, bo[22], data_readRegB);
    tri_state tsb23(ro23, bo[23], data_readRegB);
    tri_state tsb24(ro24, bo[24], data_readRegB);
    tri_state tsb25(ro25, bo[25], data_readRegB);
    tri_state tsb26(ro26, bo[26], data_readRegB);
    tri_state tsb27(ro27, bo[27], data_readRegB);
    tri_state tsb28(ro28, bo[28], data_readRegB);
    tri_state tsb29(ro29, bo[29], data_readRegB);
    tri_state tsb30(ro30, bo[30], data_readRegB);
    tri_state tsb31(ro31, bo[31], data_readRegB);


endmodule