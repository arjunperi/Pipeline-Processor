module cla_8(x,y,c0,sum,c8);
    input [7:0] x;
    input [7:0] y;
    input c0;
    output [7:0] sum; 
    output c8; 
    wire p0,p1,p2,p3,p4,p5,p6,p7; 
    wire g0,g1,g2,g3,g4,g5,g6,g7; 
    wire c1,c2,c3,c4,c5,c6,c7; 
    wire pc0,pc1,pc2,pc3,pc4,pc5,pc6,pc7;

    or x0_OR_y0(p0,x[0],y[0]);
    or x1_OR_y1(p1,x[1],y[1]);
    or x2_OR_y2(p2,x[2],y[2]);
    or x3_OR_y3(p3,x[3],y[3]);
    or x4_OR_y4(p4,x[4],y[4]);
    or x5_OR_y5(p5,x[5],y[5]);
    or x6_OR_y6(p6,x[6],y[6]);
    or x7_OR_y7(p7,x[7],y[7]);

    and x0_and_y0(g0,x[0],y[0]);
    and x1_and_y1(g1,x[1],y[1]);
    and x2_and_y2(g2,x[2],y[2]);
    and x3_and_y3(g3,x[3],y[3]);
    and x4_and_y4(g4,x[4],y[4]);
    and x5_and_y5(g5,x[5],y[5]);
    and x6_and_y6(g6,x[6],y[6]);
    and x7_and_y7(g7,x[7],y[7]);

    and p0_and_c0(pc0,p0,c0);
    or g0_or_pc0(c1,g0,pc0); 

    and p1_and_c1(pc1,p1,c1);
    or g1_or_pc1(c2,g1,pc1); 

    and p2_and_c2(pc2,p2,c2);
    or g2_or_pc2(c3,g2,pc2); 

    and p3_and_c3(pc3,p3,c3);
    or g3_or_pc3(c4,g3,pc3); 

    and p4_and_c4(pc4,p4,c4);
    or g4_or_pc4(c5,g4,pc4); 

    and p5_and_c5(pc5,p5,c5);
    or g5_or_pc5(c6,g5,pc5); 

    and p6_and_c6(pc6,p6,c6);
    or g6_or_pc6(c7,g6,pc6); 

    and p7_and_c7(pc7,p7,c7);
    or g7_or_pc7(c8,g7,pc7);

    xor sum0(sum[0],x[0],y[0],c0); 
    xor sum1(sum[1],x[1],y[1],c1);
    xor sum2(sum[2],x[2],y[2],c2);
    xor sum3(sum[3],x[3],y[3],c3);
    xor sum4(sum[4],x[4],y[4],c4);
    xor sum5(sum[5],x[5],y[5],c5);
    xor sum6(sum[6],x[6],y[6],c6);
    xor sum7(sum[7],x[7],y[7],c7);

endmodule


