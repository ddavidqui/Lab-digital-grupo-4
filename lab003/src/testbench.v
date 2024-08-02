

`include "topmodule.v"
`timescale 1ns/1ns

module tb_;
reg [2:0] a_tb; //Registro de entradas
reg [2:0] b_tb;
reg ci_tb;

//

 
top_module uut (
    .a(a_tb),
    .b(b_tb),
    .ci(ci)
    );




initial begin
    
    a_tb = 3'b000;
    b_tb = 3'b000;
    ci_tb = 1'b0;
    #2;

    a_tb = 3'b001;
    b_tb = 3'b010;
    #2;

    a_tb = 3'b011;
    b_tb = 3'b011;
    #2;

    a_tb = 3'b111;
    b_tb = 3'b001;
    #2;

    a_tb = 3'b111;
    b_tb = 3'b111;
    #2;
end 



initial begin
    $dumpfile("tbsimul.vcd");
    $dumpvars(-1, uut);
    #20 $finish;
end

endmodule
