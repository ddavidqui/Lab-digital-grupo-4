`include "top.v"
`timescale 1ns / 1ps

module testbench_parqueadero;

    // Entradas
    reg clk50;
    reg echo;

    // Salidas
    wire trig;
    wire buzzer_out;
    wire red_led, green_led, blue_led;

    // Instancia del módulo principal (top)
    top uut (
        .clk50(clk50),
        .trig(trig),
        .echo(echo),
        .buzzer_out(buzzer_out),
        .red_led(red_led),
        .green_led(green_led),
        .blue_led(blue_led)
    );

    // Generador de reloj
    always #10 clk50 = ~clk50;  // Reloj de 50 MHz (periodo de 20 ns)

    initial begin
        // Inicialización
        clk50 = 0;
        echo = 0;

        // Esperar un tiempo antes de comenzar
        #100;

        // Simulación de diferentes distancias

        // 1. Distancia menor a 10 cm (se enciende el buzzer y el LED rojo)
        echo = 1;  // Simula eco para distancia de 5 cm
        #580;      // Tiempo para el eco
        echo = 0;
        #100000;   // Esperar a que el sistema procese la distancia

        // 2. Distancia entre 10 cm y 30 cm (se enciende el LED azul)
        echo = 1;  // Simula eco para distancia de 24 cm
        #1400;     // Tiempo para el eco
        echo = 0;
        #100000;   // Esperar a que el sistema procese la distancia

        // 3. Distancia entre 30 cm y 50 cm (se enciende el LED verde)
        echo = 1;  // Simula eco para distancia de 31 cm
        #1800;     // Tiempo para el eco
        echo = 0;
        #100000;   // Esperar a que el sistema procese la distancia

        // 4. Distancia mayor a 50 cm (todos los LEDs deben apagarse y buzzer debe estar apagado)
        echo = 1;  // Simula eco para distancia de 52 cm
        #3000;     // Tiempo para el eco
        echo = 0;
        #100000;   // Esperar a que el sistema procese la distancia

        // Finaliza la simulación
        $finish;
    end

    // Guardar los resultados para visualizar en GTKWave
    initial begin
        $dumpfile("testparqueadero.vcd");  // Archivo para GTKWave
        $dumpvars(-1, uut);  // Guardar todas las variables del módulo de prueba
    end

endmodule
