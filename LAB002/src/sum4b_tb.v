`include "LAB002.v" // logica general

module sum4b_tb();

    reg [3:0] a_tb;    // Entrada a de 4 bits registros
    reg [3:0] b_tb;    // Entrada b de 4 bits
    reg ci_tb;         // Entrada de acarreo de 1 bit
    wire [3:0] s_tb;   // Salida s de 4 bits se modifican
    wire co_tb;        // Salida de acarreo de 1 bit

    // Instanciación del módulo sum4b bajo prueba
    sum4b uut (   //Se instancia el modulo de la logica general 
        .a(a_tb),
        .b(b_tb),
        .ci(ci_tb),
        .s(s_tb),
        .co(co_tb)
    );

    // Inicialización de las entradas
    initial begin
        // Caso de prueba 1
        a_tb = 4'b0000;
        b_tb = 4'b0000;
        ci_tb = 1'b0;
        #10;

        // Caso de prueba 2
        a_tb = 4'b0001;
        b_tb = 4'b0001;
        ci_tb = 1'b0;
        #10;

        // Caso de prueba 3
        a_tb = 4'b0010;
        b_tb = 4'b0010;
        ci_tb = 1'b0;
        #10;

        // Caso de prueba 4
        a_tb = 4'b0011;
        b_tb = 4'b0011;
        ci_tb = 1'b0;
        #10;

        // Caso de prueba 5
        a_tb = 4'b0100;
        b_tb = 4'b0100;
        ci_tb = 1'b0;
        #10;

        // Caso de prueba 6
        a_tb = 4'b0101;
        b_tb = 4'b0101;
        ci_tb = 1'b0;
        #10;

        // Caso de prueba 7
        a_tb = 4'b0110;
        b_tb = 4'b0110;
        ci_tb = 1'b0;
        #10;

        // Caso de prueba 8
        a_tb = 4'b0111;
        b_tb = 4'b0111;
        ci_tb = 1'b0;
        #10;

        // Caso de prueba 9
        a_tb = 4'b1000;
        b_tb = 4'b1000;
        ci_tb = 1'b0;
        #10;

        // Caso de prueba 10
        a_tb = 4'b1001;
        b_tb = 4'b1001;
        ci_tb = 1'b0;
        #10;

        // Caso de prueba 11
        a_tb = 4'b1010;
        b_tb = 4'b1010;
        ci_tb = 1'b0;
        #10;

        // Caso de prueba 12
        a_tb = 4'b1011;
        b_tb = 4'b1011;
        ci_tb = 1'b0;
        #10;

        // Caso de prueba 13
        a_tb = 4'b1100;
        b_tb = 4'b1100;
        ci_tb = 1'b0;
        #10;

        // Caso de prueba 14
        a_tb = 4'b1101;
        b_tb = 4'b1101;
        ci_tb = 1'b0;
        #10;

        // Caso de prueba 15
        a_tb = 4'b1110;
        b_tb = 4'b1110;
        ci_tb = 1'b0;
        #10;

        // Caso de prueba 16
        a_tb = 4'b1111;
        b_tb = 4'b1111;
        ci_tb = 1'b0;
        #10;

        // Finalización de la simulación
        
    end

    // Guardar la simulación en un archivo VCD
    initial begin
        $dumpfile("sum4b_tb.vcd");
        $dumpvars(-1, uut); //Averiguar ??

        #240 $finish;
        
        

    end

endmodule
