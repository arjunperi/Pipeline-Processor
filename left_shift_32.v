module left_shift_32(x,select,out);
    input [31:0] x; 
    input [4:0] select;  
    output [31:0] out; 
    
    wire [31:0] left_16, left_8, left_4, left_2, left_1; 
    wire [31:0] select_left_16, select_left_8, select_left_4, select_left_2, select_left_1;

    left_shift_16 ls_16(x, left_16); 
    mux_2 select_ls_16(select_left_16, select[4], x, left_16); 

    left_shift_8 ls_8(select_left_16, left_8); 
    mux_2 select_ls_8(select_left_8, select[3], select_left_16, left_8);

    left_shift_4 ls_4(select_left_8, left_4); 
    mux_2 select_ls_4(select_left_4, select[2], select_left_8, left_4);

    left_shift_2 ls_2(select_left_4, left_2);
    mux_2 select_ls_2(select_left_2, select[1], select_left_4, left_2); 

    left_shift_1 ls_1(select_left_2, left_1); 
    mux_2 select_ls_1(out, select[0], select_left_2, left_1); 

endmodule
 