module cla_32(x,y,c0,sum,Cout);
    input [31:0] x; 
    input [31:0] y; 
    input c0; 
    output [31:0] sum;
    output Cout; 
    wire c1,c2,c3; 

    cla_8 cla_block_1(x[7:0],y[7:0],c0,sum[7:0],c1); 
    cla_8 cla_block_2(x[15:8],y[15:8],c1,sum[15:8],c2); 
    cla_8 cla_block_3(x[23:16],y[23:16],c2,sum[23:16],c3); 
    cla_8 cla_block_4(x[31:24],y[31:24],c3,sum[31:24],Cout); 

endmodule