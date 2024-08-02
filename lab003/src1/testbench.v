`include "conversor.v"
`timescale 1ns/1ns
module tb_;
reg [3:0] a_tb; //Registro de entradas
//reg [2:0] b_tb;
//reg ci_tb;
 
BCDtoSSeg uut (
    .BCD(a_tb)
    
    );

initial begin
    
    a_tb = 4'b0000;
    #2;

    a_tb = 4'b0001;
    #2;

     a_tb = 4'b0010;
    #2;

    a_tb = 4'b0011;
    #2;

     a_tb = 4'b0100;
    #2;

    a_tb = 4'b0101;
    #2;

     a_tb = 4'b0110;
    #2;

    a_tb = 4'b0111;
    #2;

      a_tb = 4'b1000;
    #2;

      a_tb = 4'b1001;
    #2;

    a_tb = 4'b1010;
    #2;

    a_tb = 4'b1100;
    #2;


    a_tb = 4'b1111;
    #2;
   
end 

initial begin
    $dumpfile("tbparte1.vcd");
    $dumpvars(-1, uut);
    #50 $finish;
end

endmodule
