# **Laboratorio 04**

## **Objetivo**
El objetivo de este laboratorio es desarrollar un sistema digital que permita la visualización de un contador de cuatro dígitos en un display de 7 segmentos. Para lograrlo se diseñarán y simularán diversos módulos en Verilog como divisores de frecuencia, un contador BCD, un multiplexor de dígitos y un decodificador para displays de 7 segmentos. La integración de estos módulos en un sistema completo será clave para garantizar su correcto funcionamiento. Además, se llevará a cabo la implementación del diseño en una FPGA verificando que el comportamiento simulado coincida con el obtenido en el hardware real, lo que permitirá validar la funcionalidad del sistema en un entorno práctico.

## **Materiales**
- Placa de desarrollo FPGA (por ejemplo Xilinx Altera)
- Verilog HDL
- Software de simulación (GTKWAVE)

## **Diagrama Explicativo del Funcionamiento**
A continuación se presenta un diagrama que ilustra el funcionamiento general del sistema diseñado. Este diagrama describe la relación entre los diferentes módulos que componen el contador de cuatro dígitos, mostrando cómo interactúan entre sí para proporcionar la salida correcta en el display de 7 segmentos.

![](/lab004/Imagenes_Lab004/diagramaexplicativo.png)


### **En el diagrama se puede observar lo siguiente:**
- **Entrada de Señales:** Las señales principales (clk, rst y selector) se utilizan para controlar el comportamiento del sistema.
- **Divisores de Frecuencia (div_f):** A partir de la señal de reloj (clk) se generan diferentes frecuencias según la configuración seleccionada. Esta señal dividida es crucial para el correcto conteo y visualización en el display.
- **Contador:** El módulo contador recibe la señal de reloj dividida y genera las salidas BCD correspondientes a cada dígito del contador. Este módulo asegura que el conteo se realice de manera ordenada desde las unidades hasta las miles.
- **Multiplexor:** La función del multiplexor es seleccionar el dígito activo en cada instante, permitiendo que el display de 7 segmentos muestre los dígitos uno por uno de forma rápida, creando la ilusión de que todos los dígitos están encendidos simultáneamente.
- **Conversor:** Finalmente, el conversor toma la salida BCD y la convierte en la configuración adecuada para activar los segmentos del display, lo que permite que cada dígito se visualice correctamente.

## **Procedimiento**

### **1. Implementación del Divisor de Reloj**

#### **1.1 Descripción**
El reloj principal de la FPGA (50 MHz) es demasiado rápido para nuestras necesidades de visualización, por lo que necesitamos dividirlo en frecuencias más bajas. El divisor de reloj es un módulo clave que genera relojes más lentos a partir del reloj principal, permitiendo la operación de otros módulos a frecuencias manejables.

#### **1.2 Código del Divisor de Reloj**
```
module clock_divider(
    input wire clk,        // Reloj principal (por ejemplo, 50 MHz)
    input wire reset,      // Señal de reinicio
    output reg clk_div     // Reloj dividido
);

    parameter DIVISOR = 50000000; // Parámetro para ajustar la frecuencia (por defecto 1 Hz)

    reg [31:0] clk_count;  // Contador de 32 bits para soportar diferentes divisores

    always @(posedge clk or negedge reset) begin
        if (reset==0) begin
            clk_count <= 0;
            clk_div <= 0;
        end else begin
            if (clk_count == DIVISOR - 1) begin
                clk_count <= 0;
                clk_div <= ~clk_div;  // Divide la frecuencia del reloj
            end else begin
                clk_count <= clk_count + 1;
            end
        end
    end

endmodule
```
#### **1.3 Explicación Detallada**
- **clk (input wire):** Señal de reloj principal que en este caso es de 50 MHz.
- **reset (input wire):** Señal de reinicio que al activarse pone el contador y la salida a cero.
- **clk_div (output reg):** La señal de reloj dividida que tiene una frecuencia mucho menor.
- **parameter DIVISOR:** Este parámetro define cuántos ciclos del reloj principal deben ocurrir para que la señal clk_div cambie de estado, determinando así la nueva frecuencia.
- **clk_count:** Este contador acumula los ciclos de reloj hasta llegar al valor del divisor.
- **always @(posedge clk or posedge reset):** Este bloque siempre se ejecuta en cada flanco positivo del reloj o cuando se activa el reset. Cuando el contador alcanza el valor especificado por DIVISOR, se reinicia a 0 y cambia el estado de clk_div, creando así un nuevo reloj con una frecuencia más baja.

### **2. Implementación del Contador BCD**

#### **2.1 Descripción**
El contador BCD (Decimal Codificado en Binario) es responsable de contar de 0 a 9999 en cuatro dígitos. Cada dígito BCD se utiliza para representar un dígito decimal en el display de 7 segmentos.

#### **2.2 Código del Contador**
```
module contador(
    input clk_div,       // Señal de reloj dividido
    input reset,         // Señal de reinicio
    output reg [3:0] bcd0, // Salida BCD del dígito menos significativo (unidad)
    output reg [3:0] bcd1, // Salida BCD del siguiente dígito (decena)
    output reg [3:0] bcd2, // Salida BCD del siguiente dígito (centena)
    output reg [3:0] bcd3  // Salida BCD del dígito más significativo (mil)
);

    always @(posedge clk_div or negedge reset) begin
        if (reset==0) begin
            bcd0 <= 4'd0;
            bcd1 <= 4'd0;
            bcd2 <= 4'd0;
            bcd3 <= 4'd0;
        end else begin
            if (bcd0 == 4'd9) begin
                bcd0 <= 4'd0;
                if (bcd1 == 4'd9) begin
                    bcd1 <= 4'd0;
                    if (bcd2 == 4'd9) begin
                        bcd2 <= 4'd0;
                        if (bcd3 == 4'd9) begin
                            bcd3 <= 4'd0;
                        end else begin
                            bcd3 <= bcd3 + 1;
                        end
                    end else begin
                        bcd2 <= bcd2 + 1;
                    end
                end else begin
                    bcd1 <= bcd1 + 1;
                end
            end else begin
                bcd0 <= bcd0 + 1;
            end
        end
    end
endmodule
```
#### **2.3 Explicación Detallada**
- **clk_div (input):** Señal de reloj dividida por el módulo de división que impulsa el contador.
- **reset (input):** Señal que al activarse reinicia todos los dígitos del contador a 0.
- **bcd0, bcd1, bcd2, bcd3 (outputs):** Estos son los cuatro dígitos BCD del contador, representando unidades, decenas, centenas y miles respectivamente.

El bloque `always` se activa en cada flanco positivo del reloj dividido. Si el contador alcanza 9 en cualquier dígito, se reinicia a 0 y se incrementa el siguiente dígito. Este proceso se repite para cada dígito hasta alcanzar 9999, tras lo cual todo el contador se reinicia.

### **3. Multiplexor de 7 Segmentos**

#### **3.1 Descripción**
El multiplexor selecciona cuál de los cuatro dígitos BCD se muestra en el display de 7 segmentos en un momento dado. Esto se hace a alta velocidad para que, aunque sólo un dígito esté activo en un momento, todos parezcan estar encendidos simultáneamente.

#### **3.2 Código del Multiplexor**
```
module seven_segment_mux(
    input wire [3:0] bcd0, bcd1, bcd2, bcd3,
    input wire [1:0] select,  // Selección para alternar entre los dígitos
    output reg [3:0] digit
);

    always @(*) begin
        case(select)
            2'b00: digit = bcd0;
            2'b01: digit = bcd1;
            2'b10: digit = bcd2;
            2'b11: digit = bcd3;
            default: digit = 4'b0000;
        endcase
    end
endmodule
```
#### **3.3 Explicación Detallada**
- **bcd0, bcd1, bcd2, bcd3 (inputs):** Los cuatro dígitos BCD que pueden mostrarse en el display.
- **select (input):** Señal que determina cuál de los dígitos se selecciona para mostrarse.
- **digit (output):** El dígito BCD seleccionado para mostrar en el display.

El multiplexor utiliza un `case` para seleccionar uno de los cuatro dígitos BCD basado en el valor de la señal `select`. Esta señal cambia rápidamente para alternar entre los dígitos, permitiendo que cada uno se muestre en sucesión rápida.

### **4. Conversor de 7 Segmentos**

#### **4.1 Descripción**
Este módulo convierte el dígito BCD seleccionado en el código correspondiente para ser mostrado en un display de 7 segmentos.

#### **4.2 Código del Conversor**
```
module seven_segment_display(
    input [3:0] digit,
    output reg [6:0] seg
);

    always @(*) begin
        case(digit)
								 //abcdefg				
            4'd0: seg = 7'b0000001; // 0
            4'd1: seg = 7'b1001111; // 1
            4'd2: seg = 7'b0010010; // 2
            4'd3: seg = 7'b0000110; // 3
            4'd4: seg = 7'b1001100; // 4
            4'd5: seg = 7'b0100100; // 5
            4'd6: seg = 7'b1100000; // 6
            4'd7: seg = 7'b0001111; // 7
            4'd8: seg = 7'b0000000; // 8
            4'd9: seg = 7'b0001100; // 9
            default: seg = 7'b0000000; // Default (apagado)
        endcase
    end

endmodule
```
#### **4.3 Explicación Detallada**

- **Entradas y Salidas:**
  - **digit:** Es la entrada que recibe un valor de 4 bits (un dígito en BCD) y corresponde al número que se desea mostrar en el display.
  - **seg:** Es la salida de 7 bits que controla los segmentos del display. Cada bit en `seg` representa uno de los segmentos del display (a, b, c, d, e, f, g).

- **Comportamiento del Módulo:**
  - El módulo utiliza una sentencia `always` sensible a cualquier cambio en el valor de `digit`.
  - La sentencia `case` se utiliza para determinar qué segmentos deben encenderse para mostrar el dígito correspondiente.
  - Por ejemplo, cuando `digit` es `4'd0`, `seg` toma el valor `7'b0111111`, encendiendo los segmentos necesarios para formar el número "0" en el display.

- **Valores de Segmentos:**
  - Cada número del 0 al 9 tiene una combinación específica de segmentos que deben encenderse, lo que se define en el `case`.
  - El valor por defecto (`default`) es `7'b0000000`, lo que apaga todos los segmentos en caso de que se reciba un valor inválido o no esperado.

### **5. Divisor de Reloj de 16 ms**

#### **5.1 Descripción**
El divisor de reloj de 16 ms es crucial para controlar la velocidad a la que los dígitos se multiplexan en el display de 7 segmentos. Este divisor genera una señal que cambia de estado cada 16 ms, lo que es lo suficientemente rápido como para que el ojo humano no perciba el parpadeo de los dígitos, dando la ilusión de que todos están encendidos simultáneamente.

#### **5.2 Código del Divisor de 16 ms**
```
module clock_divider_16ms(
    input wire clk,        // Reloj principal (por ejemplo, 50 MHz)
    input wire reset,      // Señal de reinicio
    output reg clk_div     // Reloj dividido de 16 ms
);

    reg [19:0] clk_count;  // Contador de 20 bits para contar hasta 800,000

    always @(posedge clk or negedge reset) begin
        if (reset == 0) begin
            clk_count <= 0;
            clk_div <= 0;
        end else begin
            if (clk_count == 80000 - 1) begin  // Contar hasta 800,000
                clk_count <= 0;
                clk_div <= ~clk_div;  // Cambiar el estado del reloj dividido
            end else begin
                clk_count <= clk_count + 1;
            end
        end
    end

endmodule
```
#### **5.3 Explicación Detallada**
- **clk (input):** Señal de reloj principal, en este caso de 50 MHz.
- **reset (input):** Señal que reinicia el contador y la salida.
- **clk_div (output):** Señal de reloj dividido con un periodo de 16 ms.

Este módulo cuenta hasta 800000 ciclos del reloj de 50 MHz antes de cambiar el estado de `clk_div`. Esto resulta en una señal de salida que alterna su estado cada 16 ms, lo que es ideal para el multiplexado de dígitos.

### **6. Top Module**

#### **6.1 Descripción**
El top module es la integración de todos los componentes anteriores. Controla el sistema completo seleccionando las frecuencias de reloj, manejando el conteo en BCD y mostrando los resultados en un display de 7 segmentos.

#### **6.2 Código del Top Module**
```
//`include "divisor.v"
//`include "divisor_16.v"
//`include "contador.v"
//`include "mux.v"
//`include "conversor.v"

module top_module(
    input wire clk,        // Reloj principal (por ejemplo, 50 MHz)
    input wire reset,      // Señal de reinicio
    input wire sw1,        // Switch para seleccionar la escala de tiempo
    input wire sw2,        // Segundo switch para seleccionar la escala de tiempo
    output wire [6:0] seg, // Salida para el display de 7 segmentos
    output wire [3:0] an   // Salida para seleccionar el dígito activo
);

    // Señales internas
    wire clk_div_1Hz, clk_div_10Hz, clk_div_100Hz, clk_div_1kHz, clk_div_16ms;
    wire [3:0] bcd0, bcd1, bcd2, bcd3;
    wire [3:0] digit;
    reg [1:0] mux_select;
    reg clk_div_selected;

    // Instancias de los divisores de reloj
    clock_divider #(25000000) clk_div_1Hz_inst ( // 1 Hz
        .clk(clk),
        .reset(reset),
        .clk_div(clk_div_1Hz)
    );

    clock_divider #(2500000) clk_div_10Hz_inst ( // 10 Hz
        .clk(clk),
        .reset(reset),
        .clk_div(clk_div_10Hz)
    );

    clock_divider #(250000) clk_div_100Hz_inst ( // 100 Hz
        .clk(clk),
        .reset(reset),
        .clk_div(clk_div_100Hz)
    );

    clock_divider #(25000) clk_div_1kHz_inst ( // 1 kHz
        .clk(clk),
        .reset(reset),
        .clk_div(clk_div_1kHz)
    );

    clock_divider_16ms clk_div_16ms_inst (
        .clk(clk),
        .reset(reset),
        .clk_div(clk_div_16ms)
    );

    // Multiplexor para seleccionar el reloj basado en los switches
    always @(*) begin
        case ({sw1, sw2})
            2'b00: clk_div_selected = clk_div_1Hz;     // Segundos
            2'b01: clk_div_selected = clk_div_10Hz;    // Décimas
            2'b10: clk_div_selected = clk_div_100Hz;   // Centésimas
            2'b11: clk_div_selected = clk_div_1kHz;    // Milésimas
            default: clk_div_selected = clk_div_1Hz;
        endcase
    end

    // Instancia del contador
    contador contador_inst (
        .clk_div(clk_div_selected),
        .reset(reset),
        .bcd0(bcd0),
        .bcd1(bcd1),
        .bcd2(bcd2),
        .bcd3(bcd3)
    );

    // Módulo multiplexor para seleccionar el dígito activo
    seven_segment_mux mux_inst (
        .bcd0(bcd0),
        .bcd1(bcd1),
        .bcd2(bcd2),
        .bcd3(bcd3),
        .select(mux_select),
        .digit(digit)
    );

    // Decodificador de siete segmentos
    seven_segment_display display_inst (
        .digit(digit),
        .seg(seg)
    );

    // Control de la señal de selección
    always @(posedge clk_div_16ms or negedge reset) begin
        if (reset==0) begin
            mux_select <= 2'b00;
        end else begin
            mux_select <= mux_select + 1;
        end
    end

    // Control de los ánodos para seleccionar el dígito activo
    assign an = ~(4'b0001 << mux_select);  // Selección de dígito activa baja

endmodule
```
#### **6.3 Explicación Detallada**
- **Divisores de reloj y multiplexor:** Estos se combinan para gestionar la frecuencia y la visualización de los dígitos.
- **Contador BCD:** Lleva la cuenta desde 0 hasta 9999 y envía los valores BCD correspondientes a los displays.
- **Decodificador de 7 segmentos:** Convierte los valores BCD a señales que controlan los displays de 7 segmentos.
- **clk (input):** Señal de reloj principal, en este caso de 50 MHz.
- **reset (input):** Señal que reinicia todos los módulos.
- **sw1 y sw2 (inputs):** Switches que permiten seleccionar la frecuencia del reloj dividido.
- **seg (output):** Señal de salida que controla los segmentos del display.
- **an (output):** Señal de salida que controla los ánodos del display.

El top module se encarga de conectar y coordinar todos estos módulos para que trabajen juntos de manera coherente y eficiente. Este módulo también se encarga de la inicialización y reseteo del sistema, asegurando que todos los componentes comiencen en un estado conocido y estable.

Este módulo conecta todos los componentes anteriores. Dependiendo del valor de sw1 y sw2, selecciona una de las cuatro frecuencias divididas para alimentar el contador BCD. Luego, multiplexa los cuatro dígitos BCD para mostrar el número completo en el display de 7 segmentos.

## 7. Testbench

### 7.1 Descripción

El testbench verifica el correcto funcionamiento del sistema en un entorno de simulación antes de implementarlo en hardware. Simula las señales de reloj y de reset, así como la operación de los switches.

### 7.2 Código del Testbench
```
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
```
### 7.3 Explicación Detallada

- **Declaración de Señales:** Se definen las señales necesarias (clk, reset, sw1, sw2) como registros (reg), ya que se les asignarán valores en el testbench. Las salidas seg y an se definen como cables (wire) y se conectan a las salidas del módulo top_module.
- **Instancia del Módulo Principal:** El módulo top_module se instancia con el nombre \`uut\` (Unidad bajo Prueba - Unit Under Test). Las señales declaradas en el testbench se conectan a las entradas y salidas del top_module.
- **Generador de Reloj:** Se implementa un generador de reloj que invierte el valor de \`clk\` cada 10 nanosegundos (\`#10\`), simulando un reloj de 50 MHz.
- **Proceso de Simulación:** En el bloque \`initial\`, se inicializan todas las señales (\`clk\`, \`reset\`, \`sw1\`, \`sw2\`). Después de 100 nanosegundos (\`#100\`), se desactiva la señal de \`reset\`, permitiendo que el sistema comience a funcionar. Los switches \`sw1\` y \`sw2\` se alternan en diferentes combinaciones para probar las diferentes frecuencias de reloj seleccionadas en el \`top_module\`.
- **Simulación y Almacenamiento de Resultados:** La simulación se ejecuta por un tiempo prolongado (\`#1000000000\`) para observar el comportamiento del sistema. El testbench finaliza con \`$finish\`, y los resultados de la simulación se guardan en un archivo \`.vcd\` (\`top_module_tb.vcd\`) para su análisis en un software de visualización como GTKWave.

## 8. Simulación

La imagen siguiente es una captura de pantalla de la simulación realizada en el software de simulación (por ejemplo, GTKWave). En esta simulación, se puede observar el comportamiento del sistema implementado, incluyendo la señal de reloj dividida, el conteo en BCD, la selección de dígitos mediante el multiplexor, y la salida correspondiente para el display de 7 segmentos. La simulación confirma que el sistema cuenta correctamente de 0 a 9999, alternando los dígitos en el display de manera secuencial y sin errores.

![](/lab004/Imagenes_Lab004/simulación.png)
![](/lab004/Imagenes_Lab004/simulacion2.png)


## Conclusión

En este laboratorio, logramos implementar y verificar un sistema completo de control para un display de 7 segmentos utilizando Verilog. El proyecto incluyó la implementación de un divisor de reloj, un contador BCD, un multiplexor de dígitos, y un decodificador de 7 segmentos. A través de la simulación, se validó que el diseño funciona correctamente y cumple con los requisitos especificados. La implementación en hardware también demostró un rendimiento fiable, mostrando los números de forma clara y sin parpadeos perceptibles, gracias al uso del multiplexor y del divisor de reloj de 16 ms.


> Nota: Somos el grupo que presentó en clase el funcionamiento de este laboratorio en la FPGA, y por esta razón no montamos un video adicional.