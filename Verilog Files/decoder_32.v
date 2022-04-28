module decoder_32(out,select,enable);
    input [4:0] select;
    input enable; 
    output [31:0] out; 
    
    left_shift_32 ls(enable, select, out); 
endmodule