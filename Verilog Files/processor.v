/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */
    wire [31:0] pcIn; 
    wire [31:0] fdIrOut; 
    wire [31:0] fdPcOut;
    wire [31:0] dxIrOut; 
    wire [31:0] dxBOut; 
    wire [31:0] dxAOut; 
    wire [31:0] dxPcOut; 
    wire msb; 
    wire [31:0] immediate; 
    wire [31:0] aluChoice; 
    wire aluInputSelect;
    wire [31:0] aluOut; 
    wire [4:0] aluOP; 
    wire [4:0] aluShamt;
    wire aluNE; 
    wire aluLT; 
    wire aluOvf; 
    wire [31:0] xmIrOut; 
    wire [31:0] mwDout; 
    wire [31:0] mwOOut; 

    wire adder1c0; 
    wire adder1cOut; 
    wire [31:0] adder1Sum;
    wire pcSelectOut; 
    wire dataWriteRegChoice;
    wire [31:0] mwIrOut;

    wire aluOpChoice; 

    wire rtXmCompare;
    wire rsXmCompare;
    wire rtMwCompare; 
    wire rsMwCompare;

    wire [1:0] bypassOpA; 
    wire [1:0] bypassOpB; 

    wire [31:0] bypassAMuxOut; 
    wire [31:0] bypassBMuxOut; 

    wire notClock;

    wire multOn;
    wire divOn;
    wire ctrl_MULT; 
    wire ctrl_DIV;
    wire [31:0] multDivResult; 
    wire data_exception, data_resultRDY;

    wire multDivOperation;
    wire multDivOn;
    wire stall; 
    wire negateStall;

    wire [31:0] pwPOut;
    wire [31:0] pwIrOut;

    wire mwODchoice; 
    wire mwODop; 
    wire [1:0] dataWriteRegOp;
    wire dataWriteTemp;

    wire aluOperation = mwIrOut[31:27] == 5'd0; 
    wire addiOperation = mwIrOut[31:27] == 5'b00101; 
    wire lwOperation = mwIrOut[31:27] == 5'b01000;
    wire jalOperation = mwIrOut[31:27] == 5'b00011;
    wire setxOperation = mwIrOut[31:27] == 5'b10101; 

    //eventually update this when implementing jump
    wire [31:0] tempJump;

    //stall logic for load/store hazards
    //need to use flip flop here to make the mem stall pulse for one clock cycle
    wire memStallTemp;

    //Lecture slides compare FD to DX, hold the instruction and FD and let the DX pass
    //Instead, just compare DX to XM and stall everything?
    //xm is a load and dx is an ALU or addi
    assign memStallTemp = ((xmIrOut[31:27] == 5'b01000) && ((dxIrOut[31:27] == 5'b0 || dxIrOut[31:27] == 5'b00101 ) && dxIrOut != 32'b0)) && 
    ((dxIrOut[21:17] == xmIrOut[26:22] && dxIrOut[21:17] != 5'b0) || 
    (dxIrOut[16:12] == xmIrOut[26:22]  && dxIrOut[16:12] != 5'b0));

    wire memStallDffeOut;
    dffe_ref memStallDffe(memStallDffeOut, memStallTemp, notClock, 1'b1, reset);
    wire memStallDffeNot;
    not memStallNot(memStallDffeNot, memStallDffeOut); 
    wire memStall;
    and memStallAnd(memStall, memStallDffeNot, memStallTemp);

    register_32 PC(address_imem, pcIn, notClock, negateStall, reset);

    //add 1
    assign adder1c0 = 32'd0;
    // assign one = 32'd1;
    cla_32 add1(address_imem, 32'd1, adder1c0, adder1Sum, adder1cOut);



    //tells us which branch sum to take
    //if bne, then take our bne sum
    //if blt then take our blt sum
    wire [31:0] branchSum; 
    assign branchSum = bltTaken ? bltAdderSum : bneAdderSum;


    
    //if either branch was taken, go with branch sum
    //if blt was taken, branch sum will be bltSum
    //if bne was taken, branch sum will be bneSum
    //if both, branch sum will be bltSum


    wire jalOpCode = 5'b00011;
    //bypass logic for jumping 
    //if there is ever a jal instruction ahead of us in the pipeline (not the writeback stage), we need to know
    //so that we don't branch or jump until we let the jal finish
    wire jalAhead = (dxIrOut[31:27] == jalOpCode || xmIrOut[31:27] == jalOpCode);
     


    //Bex taken in the fd stage -> PC = bexImmediate
    //else -> PC = adder1Sum (no branches or jumps taken)
    wire [31:0] checkBex; 
    assign checkBex = bexTaken ? bexImmediate : adder1Sum;
    //J in the fd stage -> PC = jImmediate
    //else -> PC = result of if bex was taken in the fd stage or not
    wire [31:0] checkJ;
    assign checkJ = isJ ? jImmediate : checkBex;
    //Jr in the fd stage -> PC = jrRd
    //else -> PC = result of if j is in the fd stage or not
    wire [31:0] checkJr;
    assign checkJr = isJr ? jrRd : checkJ;
    //bne taken in the fd stage -> PC = bneAdderSum
    //else -> PC = result of if Jr is in the fd stage or not
    wire [31:0] checkBne;
    assign checkBne = bneTaken ? bneAdderSum : checkJr;
    //blt taken in the dx stage -> PC = bltAdderSum
    //else -> PC = result of if bne taken in the fd stage or not
    wire [31:0] checkBlt;
    assign checkBlt = bltTaken ? bltAdderSum : checkBne;
    //jal ahead in the pipeline -> PC = adder1sum
    //else -> PC = result of if blt was taken on the dx stage or not
    wire [31:0] checkJalAhead;
    assign checkJalAhead = jalAhead ? adder1Sum : checkBlt;
    //jal in the writeback stage -> PC = jalImmediate
    //else -> PC = result of if jal is ahead in the pipeline or not
    assign pcIn = isJal ? jalImmediate : checkJalAhead; 


    not negateClock(notClock, clock);
    
    //FD
    wire [31:0] fdIRChoice; 
    wire branchTaken;
    assign branchTaken = bltTaken || bneTaken || bexTaken;
    // assign fdIRChoice = (branchTaken || isJal || isJ || isJr) ? 32'd0 : q_imem; 
    assign fdIRChoice = (branchTaken || isJal || isJr) ? 32'd0 : q_imem; 
    register_32 fdIR(fdIrOut, fdIRChoice, notClock, negateStall, reset);
    register_32 fdPC(fdPcOut, address_imem, notClock, negateStall,reset); 

    

    assign ctrl_readRegA = isBex ? 5'd30 : fdIrOut[21:17];
    assign ctrl_readRegB = fdIrOut[31:27] == 5'b0 ? fdIrOut[16:12] : fdIrOut[26:22];

    //JR
    wire isJr; 
    assign isJr = fdIrOut[31:27] == 5'b00100;
    wire [31:0] jrRd;
    assign jrRd = correctRD;
    wire [31:0] jrImmediate; 
    assign jrImmediate = fdImmediate;

    //J
    wire isJ;
    assign isJ = fdIrOut[31:27] == 5'b00001; 
    wire [31:0] jImmediate; 
    assign jImmediate[26:0] = fdIrOut[26:0];
    wire jImmediateMsb = fdIrOut[26];
    assign jImmediate[27] = jImmediateMsb;
    assign jImmediate[28] = jImmediateMsb;
    assign jImmediate[29] = jImmediateMsb;
    assign jImmediate[30] = jImmediateMsb;
    assign jImmediate[31] = jImmediateMsb;



    //BEX
    wire isBex;
    assign isBex = fdIrOut[31:27] == 5'b10110;
    wire bexTrue; 
    assign bexTrue = correctRstatus != 32'b0;
    wire bexTaken;
    assign bexTaken = isBex && bexTrue;
    wire [31:0] bexImmediate; 
    assign bexImmediate = fdImmediate;

    //BEX BYPASSING -> SETX IS SOMEWHERE AHEAD
    wire [31:0] checkSetxMw; 
    assign checkSetxMw = isSetxMw ? setxMwImmediate : data_readRegA;
    wire [31:0] checkSetxXm; 
    assign checkSetxXm = isSetxXm ? setxXmImmediate : checkSetxMw; 
    wire [31:0] correctRstatus;
    assign correctRstatus = isSetxDx ? setxDxImmediate : checkSetxXm;

    //get the immediate value in the decode stage and sign extend it
    wire [31:0] fdImmediate;
    assign fdImmediate[16:0] = fdIrOut[16:0];
    wire fdMsb;
    assign fdMsb = fdIrOut[16];
    assign fdImmediate[17] = fdMsb;
    assign fdImmediate[18] = fdMsb;
    assign fdImmediate[19] = fdMsb;
    assign fdImmediate[20] = fdMsb;
    assign fdImmediate[21] = fdMsb;
    assign fdImmediate[22] = fdMsb;
    assign fdImmediate[23] = fdMsb;
    assign fdImmediate[24] = fdMsb;
    assign fdImmediate[25] = fdMsb;
    assign fdImmediate[26] = fdMsb;
    assign fdImmediate[27] = fdMsb;
    assign fdImmediate[28] = fdMsb;
    assign fdImmediate[29] = fdMsb;
    assign fdImmediate[30] = fdMsb;
    assign fdImmediate[31] = fdMsb;

    wire bne; 
    //rs != rd
    wire [31:0] correctRD; 
    wire [31:0] correctRS; 
    assign bne = correctRS != correctRD;

    //PC = PC + 1 + N
    wire [31:0] nPlus1Out;
    wire nPlus1Cout;
    cla_32 nPlus1(32'd1, fdImmediate, 32'd0, nPlus1Out, nPlus1Cout);
    //carry in of this carry out of the last one? 
    wire [31:0] bneAdderSum;
    wire bneAdderCout;
    cla_32 bneAdder(fdPcOut, nPlus1Out, nPlus1Cout, bneAdderSum, bneAdderCout);

    wire isBne;
    assign isBne = fdIrOut[31:27] == 5'b00010;
    wire bneTaken;
    and bneAnd(bneTaken, isBne, bne); 

    //BYPASSING IN FD STAGE
    //FOR CORRECT RS AND RD USED IN BNE AND CORRECT RD USED IN JR 

    wire fdRsDxCompare;
    wire fdRsXmCompare;
    wire fdRsMwCompare;
    //fd rs = dx Rd and neither are nops
    assign fdRsDxCompare = (fdIrOut[21:17] == dxIrOut[26:22] && fdIrOut != 32'b0 && dxIrOut != 32'b0)
    //fd is a bne
    && (fdIrOut[31:27] == 5'b00010)
    //dx is alu or addi
    //FOR lw one ahead we need stalling 
    //not sure about setx
    && (dxIrOut[31:27] == 5'b0 || dxIrOut[31:27] == 5'b00101);

    //fd rs = xm Rd and neither are nops
    assign fdRsXmCompare = (fdIrOut[21:17] == xmIrOut[26:22] && fdIrOut != 32'b0 && xmIrOut != 32'b0)
    //fd is a bne
    && (fdIrOut[31:27] == 5'b00010)
    //xm is alu or addi
    //FOR lw two ahead we need stalling 
    //not sure about setx
    && (xmIrOut[31:27] == 5'b0 || xmIrOut[31:27] == 5'b00101);

    //fd rs = mw Rd and neither are nops
    assign fdRsMwCompare = (fdIrOut[21:17] == mwIrOut[26:22] && fdIrOut != 32'b0 && mwIrOut != 32'b0)
    //fd is a bne
    && (fdIrOut[31:27] == 5'b00010)
    //mw is alu or addi or lw
    //not sure about setx
    && (mwIrOut[31:27] == 5'b0 || mwIrOut[31:27] == 5'b00101 || mwIrOut[31:27] == 5'b01000);

   
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    wire fdRdDxCompare;
    wire fdRdXmCompare;
    wire fdRdMwCompare;
    //fd rd = dx Rd and neither are nops
    assign fdRdDxCompare = (fdIrOut[26:22] == dxIrOut[26:22] && fdIrOut != 32'b0 && dxIrOut != 32'b0)
    //fd is a bne or jr
    && (fdIrOut[31:27] == 5'b00010 || fdIrOut[31:27] == 5'b00100)
    //dx is alu or addi
    //FOR lw one ahead we need stalling 
    //not sure about setx
    && (dxIrOut[31:27] == 5'b0 || dxIrOut[31:27] == 5'b00101);

    // fd Rd = xm Rd and neither are nops
    assign fdRdXmCompare = (fdIrOut[26:22] == xmIrOut[26:22] && fdIrOut != 32'b0 && xmIrOut != 32'b0)
    //fd is a bne or jr
    && (fdIrOut[31:27] == 5'b00010 || fdIrOut[31:27] == 5'b00100)
    //xm is alu or addi
    //FOR lw two ahead we need stalling 
    //not sure about setx
    && (xmIrOut[31:27] == 5'b0 || xmIrOut[31:27] == 5'b00101);

    //fd rd = mw Rd and neither are nops
    assign fdRdMwCompare = (fdIrOut[26:22] == mwIrOut[26:22] && dxIrOut != 32'b0 && mwIrOut != 32'b0)
    //fd is a bne or jr 
    && (fdIrOut[31:27] == 5'b00010 || fdIrOut[31:27] == 5'b00100)
    //mw is alu or addi or lw
    //not sure about setx
    && (mwIrOut[31:27] == 5'b0 || mwIrOut[31:27] == 5'b00101 || mwIrOut[31:27] == 5'b01000);

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    //rsDX -> take the ALU out
    //rsXM -> take the address dmem
    //rsMW -> take the dataWritereg
    wire [31:0] checkFdRsMw;
    assign checkFdRsMw = fdRsMwCompare ? data_writeReg : data_readRegA;
    wire [31:0] checkFdRsXm;
    assign checkFdRsXm = fdRsXmCompare ? address_dmem : checkFdRsMw;
    assign correctRS = fdRsDxCompare? aluOut : checkFdRsXm;

    wire [31:0] checkFdRdMw;
    assign checkFdRdMw = fdRdMwCompare ? data_writeReg : data_readRegB;
    wire [31:0] checkFdRdXm;
    assign checkFdRdXm = fdRdXmCompare ? address_dmem : checkFdRdMw;
    assign correctRD = fdRdDxCompare ? aluOut : checkFdRdXm;
   
    //DX
    wire [31:0] dxIRChoice; 
    //if blt taken then inject nop
    assign dxIRChoice = (bltTaken || isJal) ? 32'd0 : fdIrOut; 
    register_32 dxIR(dxIrOut, dxIRChoice, notClock, negateStall,reset);
    register_32 dxB(dxBOut, data_readRegB, notClock, negateStall, reset);
    register_32 dxA(dxAOut, data_readRegA, notClock, negateStall, reset); 
    register_32 dxPC(dxPcOut, fdPcOut, notClock, negateStall ,reset);

  
    //get the immediate value in the execute stage and sign extend it
    assign immediate[16:0] = dxIrOut[16:0];
    assign msb = dxIrOut[16];
    assign immediate[17] = msb;
    assign immediate[18] = msb;
    assign immediate[19] = msb;
    assign immediate[20] = msb;
    assign immediate[21] = msb;
    assign immediate[22] = msb;
    assign immediate[23] = msb;
    assign immediate[24] = msb;
    assign immediate[25] = msb;
    assign immediate[26] = msb;
    assign immediate[27] = msb;
    assign immediate[28] = msb;
    assign immediate[29] = msb;
    assign immediate[30] = msb;
    assign immediate[31] = msb;

    wire blt; 
    //rd < rs
    //rs not less than rd and rs not equal to rd
    assign blt = !aluLT && aluNE;

    //PC = PC + 1 + N
    wire [31:0] nPlus1OutBlt;
    wire nPlus1CoutBlt;
    cla_32 nPlus1Blt(32'd1, immediate, 32'd0, nPlus1OutBlt, nPlus1CoutBlt);
    //carry in of this carry out of the last one? 
    wire [31:0] bltAdderSum;
    wire bltAdderCout;
    cla_32 bltAdder(dxPcOut, nPlus1OutBlt, nPlus1CoutBlt, bltAdderSum, bltAdderCout);

    wire isBlt;
    assign isBlt = dxIrOut[31:27] == 5'b00110;
    wire bltTaken;
    and bltAnd(bltTaken, isBlt, blt); 


    //choose between the bypass out of B or immediate 
    //If the opcode is all 0's then then select the output of bypass B
    //or if it's a blt bc we want to send in rd and rs rather than the immediate
    assign aluInputSelect = dxIrOut[31:27] == 5'b0 || dxIrOut[31:27] == 5'b00110; 
    mux_2 aluSelect(aluChoice, aluInputSelect, immediate, bypassBMuxOut); 

    assign aluShamt = dxIrOut[11:7];
    //if we're doing an ALU instruction (all 0's) then take the ALU op, if 
    // not then pick add

    wire [31:0] correctAluIn1;
    wire [31:0] correctAluIn2;

    assign aluOpChoice = dxIrOut[31:27] == 5'b0; 
    mux_2 aluOpSelect(aluOP, aluOpChoice, 5'd0, dxIrOut[6:2]); 

    wire [31:0] finalAluIn1; 
    wire [31:0] finalAluIn2; 
    alu primaryALU(finalAluIn1, finalAluIn2, aluOP, aluShamt, aluOut, aluNE, aluLT, aluOvf);

    //if either alu input is r30 and there exists a non 0 rstatus ahead, then replace r30 with that

    //RSTATUS BYPASSING 

    wire [31:0] checkMwRStatus1;
    assign checkMwRStatus1 = (dxIrOut[21:17] == 5'd30 && mwRStatus != 32'd0) ? mwRStatus : correctAluIn1; 
    assign finalAluIn1 = (dxIrOut[21:17] == 5'd30 && xmRStatus != 32'd0) ? xmRStatus : checkMwRStatus1;

    wire [31:0] checkMwRStatus2;
    assign checkMwRStatus2 = (dxIrOut[16:12] == 5'd30 && mwRStatus != 32'd0) ? mwRStatus : correctAluIn2; 
    assign finalAluIn2 = (dxIrOut[16:12] == 5'd30 && xmRStatus != 32'd0) ? xmRStatus : checkMwRStatus2;

   
    //all 0's signals no exception
    wire [31:0] checkAddException;
    assign checkAddException = addException ? 32'd1 : 32'd0;
    wire [31:0] checkAddiException;
    assign checkAddiException = addiException ? 32'd2 : checkAddException;
    wire [31:0] checkSubException; 
    assign checkSubException = subException ? 32'd3 : checkAddiException; 
    wire [31:0] checkMultException; 
    assign checkMultException = multException ? 32'd4 : checkSubException; 
    wire [31:0] dxRStatus;
    assign dxRStatus = divException ? 32'd5 : checkMultException;


    //if its an add and ovf
    wire isAdd; 
    assign isAdd = dxIrOut[31:27] == 5'b0 && dxIrOut[6:2] == 5'b0; 
    wire addException; 
    assign addException = aluOvf && isAdd;
    
    //if its an addi and ovf
    wire isAddi; 
    assign isAddi = dxIrOut[31:27] == 5'b00101;
    wire addiException;
    assign addiException = aluOvf && isAddi;

    //if its sub and ovf
    wire isSub; 
    assign isSub = dxIrOut[31:27] == 5'b0 && dxIrOut[6:2] == 5'b00001;
    wire subException;
    assign subException = aluOvf && isSub;

    //if mult and ovf
    wire isMult; 
    assign isMult = dxIrOut[31:27] == 5'b0 && dxIrOut[6:2] == 5'b00110;
    wire multException;
    assign multException = data_exception && isMult;
    
    //if div and exception
    wire isDiv; 
    assign isDiv = dxIrOut[31:27] == 5'b0 && dxIrOut[6:2] == 5'b00111;
    wire divException;
    assign divException = data_exception && isDiv;


    //if the destiation register is r0, the set the aluOut to 0
    wire [31:0] correctAluOut; 
    assign correctAluOut = (dxIrOut[26:22] == 5'b0) ? 32'b0 : aluOut;
    
    //Instruction for mult
    assign multOn = dxIrOut[6:2] == 5'b00110;
    //Instruction for div
    assign divOn = dxIrOut[6:2] == 5'b00111;
    //mult instruction or div instruction was read
    or multDivOr(multDivOperation, multOn, divOn);
    //mult/div instruction was read and we have an ALU opcode
    and mulDivandAlu(multDivOn, multDivOperation, aluOpChoice);

    //multdiv is currently occuring
    wire multDivNow; 
    //store the fact that multdiv is occurring, reset once it's done (RDY)
    //clock or not clock?
    dffe_ref multDivOccuring(multDivNow, multDivOn, notClock, 1'b1, data_resultRDY); 
    //assign the ctrl signals once  - when their instructions are read and multdiv is not currently occuring 
    assign ctrl_MULT = multOn & ~multDivNow;
    assign ctrl_DIV = divOn & ~multDivNow;


    wire multDivStall; 
    //stall when multdiv turns on and RDY is 0
    and stallAnd(multDivStall, multDivOn, ~data_resultRDY);

    //negate the stall because in our enables when stall is on we want to input 0 
    assign negateStall = !(multDivStall || memStall);

    multdiv multdivOperator(finalAluIn1, finalAluIn2, ctrl_MULT, ctrl_DIV, notClock, multDivResult, data_exception, data_resultRDY); 

    wire [31:0] correctMultDivResult;
    assign correctMultDivResult = (dxIrOut[26:22] == 5'b0) ? 32'b0 : multDivResult;

    //feed mult div or Alu out into address_dmem depending on the operation 
    wire [31:0] xmOChoice;
    assign xmOChoice = multDivOn ? correctMultDivResult : correctAluOut;


    //BYPASSING IN DX STAGE - FOR CORRECT RS AND RD USED IN BLT 

    wire dxRsXmCompare;
    wire dxRsMwCompare; 
    //dx rs = xm Rd and neither are nops
    assign dxRsXmCompare = (dxIrOut[21:17] == xmIrOut[26:22] && dxIrOut != 32'b0 && xmIrOut != 32'b0)
    //dx is a blt
    && (dxIrOut[31:27] == 5'b00110)
    //xm is alu or addi
    //FOR lw one ahead we need stalling 
    //not sure about setx
    && (xmIrOut[31:27] == 5'b0 || xmIrOut[31:27] == 5'b00101);

    //dx rs = mw Rd and neither are nops
    assign dxRsMwCompare = (dxIrOut[21:17] == mwIrOut[26:22] && dxIrOut != 32'b0 && mwIrOut != 32'b0)
    //dx is a blt
    && (dxIrOut[31:27] == 5'b00110)
    //mw is alu or addi or lw
    //not sure about setx
    && (mwIrOut[31:27] == 5'b0 || mwIrOut[31:27] == 5'b00101 || mwIrOut[31:27] == 5'b01000);

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////

    wire dxRdXmCompare;
    wire dxRdMwCompare;
    //dx rd = xm Rd and neither are nops
    assign dxRdXmCompare = (dxIrOut[26:22] == xmIrOut[26:22] && dxIrOut != 32'b0 && xmIrOut != 32'b0)
    //dx is a blt
    && (dxIrOut[31:27] == 5'b00110)
    //xm is alu or addi
    //FOR lw one ahead we need stalling 
    //not sure about setx
    && (xmIrOut[31:27] == 5'b0 || xmIrOut[31:27] == 5'b00101);

    //dx rd = mw Rd and neither are nops
    assign dxRdMwCompare = (dxIrOut[26:22] == mwIrOut[26:22] && dxIrOut != 32'b0 && mwIrOut != 32'b0)
    //dx is a blt
    && (dxIrOut[31:27] == 5'b00110)
    //mw is alu or addi or lw
    //not sure about setx
    && (mwIrOut[31:27] == 5'b0 || mwIrOut[31:27] == 5'b00101 || mwIrOut[31:27] == 5'b01000); 

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////


    //rsXM -> take adress dmem
    //rsMW -> take the dataWritereg
    wire [31:0] checkDxRsMw; 
    assign checkDxRsMw = dxRsMwCompare ? data_writeReg : bypassAMuxOut; 
    assign correctAluIn1 = dxRsXmCompare ? address_dmem : checkDxRsMw; 

    wire [31:0] checkDxRdMw;
    assign checkDxRdMw = dxRdMwCompare ? data_writeReg : aluChoice; 
    assign correctAluIn2 = dxRdXmCompare ? address_dmem : checkDxRdMw;


    //SETX in DX STAGE
    wire isSetxDx; 
    assign isSetxDx = dxIrOut[31:27] == 5'b10101;
    //need to get the immediate from this stage
    wire [31:0] setxDxImmediate;
    //going to be the same as what jalImmediate reads since they both read immediates from this stage
    assign setxDxImmediate[26:0] = dxIrOut[26:0];
    wire setxDxMsb;
    assign setxDxMsb = dxIrOut[26];
    assign setxDxImmediate[27] = setxDxMsb;
    assign setxDxImmediate[28] = setxDxMsb;
    assign setxDxImmediate[29] = setxDxMsb;
    assign setxDxImmediate[30] = setxDxMsb;
    assign setxDxImmediate[31] = setxDxMsb;


    //XM
    wire [31:0] xmBOut; 
    //need PC registers so we can pass PC + 1 for jal
    wire [31:0] xmPcOut;
    register_32 xmPC(xmPcOut, dxPcOut, notClock, negateStall, reset); 
    wire [31:0] xmIRChoice; 
    //if blt taken then inject nop
    assign xmIRChoice = (isJal) ? 32'd0 : dxIrOut; 
    register_32 xmIR(xmIrOut, xmIRChoice, notClock, negateStall, reset);
    register_32 xmB(xmBOut, dxBOut, notClock, negateStall,reset);
    // register_32 xmO(address_dmem, aluOut, notClock, negateStall, reset); 
    register_32 xmO(address_dmem, xmOChoice, notClock, negateStall, reset); 
    //rstatus register to carry on the exception data from the execute stage
    wire [31:0] xmRStatus;
    register_32 xmRStatusReg(xmRStatus, dxRStatus, notClock, negateStall, reset);


    //WM bypass logic - if load and then store right after
    //It could also be an ALU op or addi right before a store, anything that is writing to rd
    //or a setx 
    // we want to update the rd of the store so we store the corect data into mem
    wire wmBypass; 
    //xm Rd = mw Rd
    assign wmBypass = ((xmIrOut[26:22] == mwIrOut[26:22]) 
    //xm is a store 
    && (xmIrOut[31:27] == 5'b00111) 
    //mw is a load, ALU, addi
    && (mwIrOut[31:27] == 5'b01000 || mwIrOut[31:27] == 5'b00000 || mwIrOut[31:27] == 5'b00101)
    //mw is not a nop  
    && (mwIrOut != 32'b0))
    //OR xm Rd = 30
    || ((xmIrOut[26:22] == 5'd30) 
    //xm is a store 
    && (xmIrOut[31:27] == 5'b00111)
    //mw is a setx
    && (isSetxMw));


    //SETX IN XM STAGE
    wire isSetxXm; 
    assign isSetxXm = xmIrOut[31:27] == 5'b10101;
    //need to get the immediate from this stage
    wire [31:0] setxXmImmediate;
    //going to be the same as what jalImmediate reads since they both read immediates from this stage
    assign setxXmImmediate[26:0] = xmIrOut[26:0];
    wire setxXmMsb;
    assign setxXmMsb = xmIrOut[26];
    assign setxXmImmediate[27] = setxXmMsb;
    assign setxXmImmediate[28] = setxXmMsb;
    assign setxXmImmediate[29] = setxXmMsb;
    assign setxXmImmediate[30] = setxXmMsb;
    assign setxXmImmediate[31] = setxXmMsb;


    assign data = wmBypass ? data_writeReg : xmBOut;

    //MW
    wire [31:0] mwPcOut;
    register_32 mwPC(mwPcOut, xmPcOut, notClock, negateStall, reset);
    wire [31:0] mwIRChoice; 
    //if blt taken then inject nop
    assign mwIRChoice = (isJal) ? 32'd0 : xmIrOut; 
    register_32 mwIR(mwIrOut, mwIRChoice, notClock, negateStall, reset);
    register_32 mwD(mwDout, q_dmem, notClock, negateStall, reset);
    register_32 mwO(mwOOut, address_dmem, notClock, negateStall, reset);
    wire [31:0] mwRStatus; 
    register_32 mwRStatusReg(mwRStatus, xmRStatus, notClock, negateStall, reset); 

    wire [4:0] normalCtrlWriteReg;
    assign normalCtrlWriteReg = mwIrOut[26:22];
   
    //JAL
    wire isJal;
    assign isJal = mwIrOut[31:27] == 5'b00011;

    wire [31:0] jalPcPlus1;
    wire jalPcPlus1Cout;
    cla_32 jalPcPlus1Adder(32'd1, mwPcOut, 32'd0, jalPcPlus1, jalPcPlus1Cout);

    wire [31:0] jalImmediate; 
    assign jalImmediate[26:0] = mwIrOut[26:0];
    wire jalMsb;
    assign jalMsb = mwIrOut[26];
    assign jalImmediate[27] = jalMsb;
    assign jalImmediate[28] = jalMsb;
    assign jalImmediate[29] = jalMsb;
    assign jalImmediate[30] = jalMsb;
    assign jalImmediate[31] = jalMsb;

    //SETX IN MW STAGE
    wire isSetxMw; 
    assign isSetxMw = mwIrOut[31:27] == 5'b10101;
    //need to get the immediate from this stage
    wire [31:0] setxMwImmediate;
    //going to be the same as what jalImmediate reads since they both read immediates from this stage and take least 27 significant bits
    assign setxMwImmediate = jalImmediate; 


    wire [4:0] checkSetxCtrl; 
    assign checkSetxCtrl = (isSetxMw || (mwRStatus != 32'b0)) ? 5'd30 : normalCtrlWriteReg; 
    //if jal, pick register 31, if not, check if it is a setX
    assign ctrl_writeReg = isJal ? 5'd31 : checkSetxCtrl;
    

    //check if we are writing from D or O registers
    wire [31:0] normalDataWrite;
    assign dataWriteRegChoice = mwIrOut[30]; 
    assign normalDataWrite = dataWriteRegChoice ? mwDout : mwOOut;
    wire [31:0] checkExceptionData; 
    assign checkExceptionData = (mwRStatus != 32'b0) ? mwRStatus : normalDataWrite; 
    wire [31:0] checkSetxData;
    assign checkSetxData = isSetxMw ? setxMwImmediate : checkExceptionData;
    assign data_writeReg = isJal ? jalPcPlus1 : checkSetxData;

  
    wire swOperation; 
    assign swOperation = xmIrOut[31:27] == 5'b00111;
    assign wren = swOperation;


    assign ctrl_writeEnable = aluOperation || addiOperation || lwOperation || jalOperation || setxOperation;
    
    //bypass logic

    //dx should be ALU or addi, the mw could be a load word or an ALU or addi
    //dx could also be load or store word because they are also doing ALU logic and we need to get the right 
    //rs value to add to the immediate, this only applies to rs

    //dx Rs = xm Rd and neither is nop
    assign rsXmCompare = dxIrOut[21:17] == xmIrOut[26:22] && dxIrOut != 32'b0 && xmIrOut != 32'b0 
    //Dx is alu, addi, lw, sw
    && (dxIrOut[31:27] == 5'b0 || dxIrOut[31:27] == 5'b00101 || dxIrOut[31:27] == 5'b01000 || dxIrOut[31:27] == 5'b00111) 
    //xm is alu, addi, lw
    && (xmIrOut[31:27] == 5'b0 || xmIrOut[31:27] == 5'b00101 || xmIrOut[31:27] == 5'b01000); 

    //dx Rs = Mw rd and neither is nop
    assign rsMwCompare = ((dxIrOut[21:17] == mwIrOut[26:22] && dxIrOut != 32'b0 && mwIrOut != 32'b0)
    //DX is alu, addi, lw, sw
    && (dxIrOut[31:27] == 5'b0 || dxIrOut[31:27] == 5'b00101 || dxIrOut[31:27] == 5'b01000 || dxIrOut[31:27] == 5'b00111) 
    //mw is alu, addi, lw
    && (mwIrOut[31:27] == 5'b0 || mwIrOut[31:27] == 5'b00101 || mwIrOut[31:27] == 5'b01000));
    //OR, rs is 30 and neither dx or mw is nop
    // || ((dxIrOut[21:17] == 5'd30 && dxIrOut != 32'b0 && mwIrOut != 32'b0)  
    // //dx is alu, addi, lw, sw
    // && (dxIrOut[31:27] == 5'b0 || dxIrOut[31:27] == 5'b00101 || dxIrOut[31:27] == 5'b01000 || dxIrOut[31:27] == 5'b00111)
    // // and mw is setx
    // && (isSetx)); 


    //same for RT's but dx should only be an ALU
    //dx Rt = xm Rd and neither is nop
    assign rtXmCompare = (dxIrOut[16:12] == xmIrOut[26:22] && dxIrOut != 32'b0 && xmIrOut != 32'b0)
    //Dx is alu
    && (dxIrOut[31:27] == 5'b0) && 
    //xm is alu, addi, lw
    (xmIrOut[31:27] == 5'b0 || xmIrOut[31:27] == 5'b00101 || xmIrOut[31:27] == 5'b01000); 

    //dx Rt = mw Rd and neither is nop
    assign rtMwCompare = ((dxIrOut[16:12] == mwIrOut[26:22] && dxIrOut != 32'b0 && mwIrOut != 32'b0)
    //dx is alu
    && (dxIrOut[31:27] == 5'b0)
    //mw is alu, addi, lw
    && (mwIrOut[31:27] == 5'b0  || mwIrOut[31:27] == 5'b00101 || mwIrOut[31:27] == 5'b01000));
    // OR, rt is 30 and neither dx or mw is nop
    // || ((dxIrOut[16:12] == 5'd30 && dxIrOut != 32'b0 && mwIrOut != 32'b0)  
    // //dx is alu
    // && (dxIrOut[31:27] == 5'b0)
    // // and mw is setx
    // && (isSetx)); 
    

    //bus together so we get a 2bit opcode for the mux
    assign bypassOpA = {rsXmCompare, rsMwCompare};
    assign bypassOpB = {rtXmCompare, rtMwCompare};


    //if memStallTemp = 1, meaning we hit the case where the lw is right before an ALU op/addi, then we want to give
    //q dmem instead of address d_mem 

    wire [31:0] wxBypassChoice; 
    assign wxBypassChoice = memStallTemp ? q_dmem : address_dmem;
    mux_4 bypassAMux(bypassAMuxOut, bypassOpA, dxAOut, data_writeReg, wxBypassChoice, wxBypassChoice);
    mux_4 bypassBMux(bypassBMuxOut, bypassOpB, dxBOut, data_writeReg, wxBypassChoice, wxBypassChoice);   
	/* END CODE */

endmodule
