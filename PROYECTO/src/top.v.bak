`include "sonic.v"
`include "buzzer.v"

module top(
    input clk50,
    output trig, 
    input echo,
     

    output buzzer_out, // Salida para el buzzer
    output red_led,    // Salida para el LED rojo
    output green_led,  // Salida para el LED verde
    output blue_led    // Salida para el LED azul
);

    wire [32:0] distance;
    wire enable_buzzer; // Señal de habilitación para el buzzer

    // Instancia del módulo del sensor
    sonic sc (
        .clock(clk50),
        .trig(trig),
        .echo(echo),
        .distance(distance),
        .buzzer(enable_buzzer), // Conectar el control del buzzer
        .red_led(red_led),       // Conectar el LED rojo
        .green_led(green_led),   // Conectar el LED verde
        .blue_led(blue_led)      // Conectar el LED azul
    );

    // Instancia del módulo del buzzer
    buzzer bz (
        .clk(clk50),              // Usar el mismo reloj
        .enable(enable_buzzer),    // Conectar habilitación
        .buzzer_out(buzzer_out)    // Conectar salida del buzzer
    );

endmodule
