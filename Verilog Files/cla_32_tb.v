`timescale 1ns/100ps
module cla_32_tb;
    reg [31:0] x,y;  
    reg c0; 
    
    wire [31:0] sum;
    wire Cout; 
   
    cla_32 cla(.x(x), .y(y), .c0(c0), .sum(sum), .Cout(Cout)); 

    initial begin
        c0 = 0; 
        x = 8388608; 
        y = 8388608;
    end
    
    always @(x,y,c0) begin
        #20;
        $display("x:%b, y:%b, Cin:%b => sum:%b, Cout:%b", x,y,c0,sum,Cout);
    end



    // integer i; 
    // assign {c0,x,y} = i[64:0]; 
    // initial begin
    //     for(i=0;i<32;i=i+1) begin
    //     #20;
    //     $display("x:%b, y:%b, Cin:%b => sum:%b, Cout:%b", x,y,c0,sum,Cout);
    //     end
    // $finish;    
    // end


    // //Define output waveform properties
    // initial begin
    //     //Output file name
    //     $dumpfile("Full_Adder_Wave.vcd");
    //     //Module to capture and what level, 0 means all wires
    //     $dumpvars(0, full_adder_tb); 
    // end
endmodule