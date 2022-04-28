module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    wire EQ,GT, not_GT; 

    wire [31:0] not_B, select_B, sum, difference, operation_result, b_result; 
    wire Cout; 


    wire [31:0] left_16, left_8, left_4, left_2, left_1; 
    wire [31:0] select_left_16, select_left_8, select_left_4, select_left_2, select_left_1;

    wire [31:0] right_16, right_8, right_4, right_2, right_1; 
    wire [31:0] select_right_16, select_right_8, select_right_4, select_right_2, select_right_1;

    wire [31:0] and_output, or_output; 

    wire [31:0] result_1, result_2;

    wire msbA;
    assign msbA = data_operandA[31]; 

    wire msbB; 
    assign msbB = data_operandB[31]; 

    wire signsDifferent, bareNGT; 

    // add your code here:

    //AND
    and_32 a_and_b(data_operandA, data_operandB, and_output); 

    //OR
    or_32 a_or_b(data_operandA, data_operandB, or_output); 

    //subtracting 
    not_32 inverse_B(data_operandB, not_B); 
    cla_32 subtract(data_operandA, not_B, 1'b1, difference, Cout); 

    //not equal
    //after subtraction, check 
    comparator_32 compare(data_operandA, data_operandB, EQ, GT);
    not neq(isNotEqual, EQ); 

    // not (msbB_not, msbB); 
    xor (signsDifferent, msbA, msbB);     
    not ngt(not_GT, GT); 
    


    and lt(bareNGT, not_GT, isNotEqual); 

    xor (isLessThan, bareNGT, signsDifferent); 

    //adding
    cla_32 add(data_operandA, data_operandB, 1'b0, sum, Cout); 

    mux_2 operation_select(operation_result, ctrl_ALUopcode[0], sum, difference); 
    mux_2 b_select(b_result, ctrl_ALUopcode[0], data_operandB, not_B); 
    overflow_checker overflow_check(data_operandA, b_result, operation_result, overflow); 

    //logical left shift
    left_shift_16 ls_16(data_operandA, left_16); 
    mux_2 select_ls_16(select_left_16, ctrl_shiftamt[4], data_operandA, left_16); 

    left_shift_8 ls_8(select_left_16, left_8); 
    mux_2 select_ls_8(select_left_8, ctrl_shiftamt[3], select_left_16, left_8);

    left_shift_4 ls_4(select_left_8, left_4); 
    mux_2 select_ls_4(select_left_4, ctrl_shiftamt[2], select_left_8, left_4);

    left_shift_2 ls_2(select_left_4, left_2);
    mux_2 select_ls_2(select_left_2, ctrl_shiftamt[1], select_left_4, left_2); 

    left_shift_1 ls_1(select_left_2, left_1); 
    mux_2 select_ls_1(select_left_1, ctrl_shiftamt[0], select_left_2, left_1); 

    //arithmetic right shift 
    right_shift_16 rs_16(data_operandA, right_16); 
    mux_2 select_rs_16(select_right_16, ctrl_shiftamt[4], data_operandA, right_16); 

    right_shift_8 rs_8(select_right_16, right_8); 
    mux_2 select_rs_8(select_right_8, ctrl_shiftamt[3], select_right_16, right_8);

    right_shift_4 rs_4(select_right_8, right_4); 
    mux_2 select_rs_4(select_right_4, ctrl_shiftamt[2], select_right_8, right_4);

    right_shift_2 rs_2(select_right_4, right_2);
    mux_2 select_rs_2(select_right_2, ctrl_shiftamt[1], select_right_4, right_2); 

    right_shift_1 rs_1(select_right_2, right_1); 
    mux_2 select_rs_1(select_right_1, ctrl_shiftamt[0], select_right_2, right_1);  

    //choose between four options
    mux_4 first_choice(result_1, ctrl_ALUopcode[1:0], sum, difference, and_output, or_output); 

    //choose between two options
    mux_2 second_choice(result_2, ctrl_ALUopcode[0], select_left_1, select_right_1);

    //get the data result 
    mux_2 final(data_result, ctrl_ALUopcode[2], result_1, result_2);


    
endmodule