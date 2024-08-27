`include "topmodule.v"
`timescale 1ns / 1ps

module testbench;

    // Señales para el reloj, reset y switches
    reg clk;
    reg reset;
    reg sw1;
    reg sw2;
    
    // Salidas
    wire [6:0] seg;
    wire [3:0] an;

    // Instancia del módulo principal (top_module)
    top_module uut (
        .clk(clk),
        .reset(reset),
        .sw1(sw1),
        .sw2(sw2),
        .seg(seg),
        .an(an)
    );

    // Generador de reloj
    always #10 clk = ~clk;  // Reloj de 50 MHz (periodo de 20 ns)

    initial begin
        // Inicialización
        clk = 0;
        reset = 1;
        sw1 = 0;
        sw2 = 0;

        // Espera un tiempo y luego libera el reset
        #100;
        reset = 0;

        // Cambiar los switches para probar diferentes modos
        #1000000;  // Esperar un tiempo
        sw1 = 1; sw2 = 0;  // Probar con sw1 en 1 y sw2 en 0
        #1000000;  // Esperar un tiempo
        sw1 = 0; sw2 = 1;  // Probar con sw1 en 0 y sw2 en 1
        #1000000;  // Esperar un tiempo
        sw1 = 1; sw2 = 1;  // Probar con ambos switches en 1

        // Simulación durante un tiempo suficiente para observar el funcionamiento
        #1000000000;  // Simular 1 ms

        // Finaliza la simulación
        $finish;
    end

    // Guardar los resultados para visualizar en GTKWave
    initial begin
        $dumpfile("top_module_tb.vcd");
        $dumpvars(-1, uut);
        #20000000000;
        $finish;
    end
    
endmodule

