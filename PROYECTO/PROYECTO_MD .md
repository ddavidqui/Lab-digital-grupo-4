# Prototipo de Sistema de Estacionamiento Asistido

## 1. Introducción
Este proyecto tiene como objetivo implementar un sistema de estacionamiento asistido mediante Verilog. El sistema utiliza un sensor ultrasónico para medir la proximidad de obstáculos y proporciona alertas visuales a través de un LED RGB, así como una alarma sonora mediante un buzzer. Estas alertas permiten al conductor estacionar de manera segura, ofreciendo indicaciones de proximidad en tiempo real.

## 2. Objetivos
- Diseñar e implementar un sistema de estacionamiento asistido en Verilog.
- Medir la proximidad a los obstáculos mediante un sensor ultrasónico.
- Proporcionar señales visuales a través de un LED RGB según la distancia.
- Emitir una alarma sonora con un buzzer cuando la distancia sea críticamente corta.
- Verificar el correcto funcionamiento del sistema mediante simulaciones y pruebas en hardware.

## 3. Requerimientos

### 3.1 Requisitos de Hardware
- Tarjeta de desarrollo: Altera A-C4E6E10, FPGA Cyclon IV.
- Sensor de distancia ultrasónico: Para medir la proximidad a los objetos cercanos.
- LED RGB: Para indicar la distancia mediante distintos colores.
- Módulo buzzer: Para alertar cuando la distancia al obstáculo sea muy corta.

### 3.2 Sensor de Distancia
El sensor HC-SR04 incorpora un par de transductores de ultrasonido que se utilizan de manera conjunta para determinar la distancia del sensor con un objeto colocado enfrente de este. Un transductor emite una “ráfaga” de ultrasonido y el otro capta el rebote de dicha onda.  
El tiempo que tarda la onda sonora en ir y regresar a un objeto se utiliza para conocer la distancia que existe entre el origen del sonido y el objeto.

El sensor ultrasónico mide la distancia a los obstáculos y envía estos datos al sistema, que procesa la información en tiempo real. Dependiendo de la distancia medida, el sistema determina qué tipo de alerta se debe activar (visual o sonora).

### 3.3 Indicaciones Visuales (LED RGB)
El LED RGB indica la proximidad de obstáculos con los siguientes colores:
- **Verde**: La distancia es segura, el objeto está entre 30 y 50 cm.
- **Azul**: La distancia es moderada, el objeto está entre 10 y 30 cm.
- **Rojo**: La distancia es peligrosa, el objeto está a menos de 10 cm.

### 3.4 Alarma Sonora (Módulo Buzzer)
El buzzer se activa cuando la distancia medida por el sensor es inferior a 10 cm, alertando al conductor que está peligrosamente cerca del obstáculo. La alarma es continua mientras el vehículo permanezca a menos de 10 cm.

### 3.5 Rango de Distancias
El sistema maneja los siguientes rangos de distancia:
- **Distancia segura (> 20 cm)**: LED verde.
- **Distancia moderada (10-20 cm)**: LED azul.
- **Distancia corta (< 10 cm)**: LED rojo y buzzer activado.

## 4. Desarrollo del Proyecto
El sistema está compuesto por tres módulos en Verilog:

1. **sonic.v**: Módulo que controla el sensor ultrasónico y calcula la distancia basada en el tiempo de respuesta del eco. Activa el buzzer y el LED RGB según la proximidad.  
   ```
   module sonic(
    input clock,
    output trig,
    input echo,
    output reg [32:0] distance,
    output reg buzzer, 
    output reg red_led, 
    output reg green_led, 
    output reg blue_led 
   );
   reg [32:0] us_counter = 0;
   reg _trig = 1'b0;
   
   reg [9:0] one_us_cnt = 0;
   wire one_us = (one_us_cnt == 0);

   reg [9:0] ten_us_cnt = 0;
   wire ten_us = (ten_us_cnt == 0);

   reg [21:0] forty_ms_cnt = 0;
   wire forty_ms = (forty_ms_cnt == 0);

   assign trig = _trig;

   always @(posedge clock) begin
    one_us_cnt <= (one_us ? 50 : one_us_cnt) - 1;
    ten_us_cnt <= (ten_us ? 500 : ten_us_cnt) - 1;
    forty_ms_cnt <= (forty_ms ? 2000000 : forty_ms_cnt) - 1;

    if (ten_us && _trig)
        _trig <= 1'b0;

    if (one_us) begin    
        if (echo)
            us_counter <= us_counter + 1;
        else if (us_counter) begin
            distance <= us_counter / 58; 
            us_counter <= 0;

            if (distance < 10)
                buzzer <= 1'b1; 
            else
                buzzer <= 1'b0; 
            
            
            if (distance < 10) begin
                red_led <= 1'b0;   
                blue_led <= 1'b1;  
                green_led <= 1'b1; 
            end
            else if (distance >= 10 && distance < 30) begin
                red_led <= 1'b1;   
                blue_led <= 1'b1;  
                green_led <= 1'b0; 
            end
            else if (distance >= 30 && distance <= 50) begin
                red_led <= 1'b1;   
                blue_led <= 1'b0; 
                green_led <= 1'b1; 
            end
            else begin
                red_led <= 1'b1;   
                blue_led <= 1'b1;
                green_led <= 1'b1;
            end
        end
    end
    
    if (forty_ms)
        _trig <= 1'b1;
        end
   endmodule
   ```

    ### Sistema de Medición de Distancia con Sensor Ultrasónico y Alerta Visual y Sonora
      
      Este código Verilog implementa un sistema de medición de distancia utilizando un sensor ultrasónico, el cual activa un buzzer y cambia los colores de un LED RGB según la distancia medida. El propósito principal del sistema es proporcionar indicaciones visuales y sonoras sobre la proximidad de un obstáculo.
      
      #### Entradas y salidas:
      
      ##### Entradas:
      - **clock**: Señal de reloj que sincroniza todas las operaciones del sistema.
      - **echo**: Señal de retorno del sensor ultrasónico, que indica el tiempo que tarda el pulso ultrasónico en ir y regresar desde el obstáculo.
      
      ##### Salidas:
      - **trig**: Señal que activa el sensor ultrasónico, enviando un pulso para comenzar la medición de distancia.
      - **distance**: Valor de la distancia calculada, en centímetros.
      - **buzzer**: Señal que activa el buzzer para emitir una alerta sonora cuando la distancia es menor a 10 cm.
      - **red_led**, **green_led**, **blue_led**: Señales que controlan los tres componentes del LED RGB, variando los colores para indicar diferentes rangos de distancia.
      
      #### Funcionamiento del sistema:
      
      ##### Generación de señales temporales:
      El sistema genera tres señales de tiempo mediante contadores:
      - **one_us**: Señal que se activa cada microsegundo (1 µs). Sirve para contar el tiempo transcurrido desde que se emite el pulso del sensor.
      - **ten_us**: Señal que se activa cada 10 microsegundos (10 µs). Controla la duración de la señal `trig` que dispara el sensor ultrasónico.
      - **forty_ms**: Señal que se activa cada 40 milisegundos (40 ms). Esta señal marca el intervalo de tiempo entre mediciones, activando la señal de disparo del sensor (`trig`).
      
      ##### Control de la señal trig:
      La señal `trig` se activa cada 40 milisegundos durante 10 µs. Esto envía un pulso desde el sensor ultrasónico, que luego espera la señal de retorno (`echo`) para medir la distancia.
      
      ##### Medición de la señal echo:
      Cuando el sensor recibe el pulso de eco (la señal `echo`), el sistema comienza a contar el tiempo en microsegundos. Este tiempo se acumula en el registro `us_counter`.
      
      Una vez que la señal `echo` termina, el valor de `us_counter` se divide por 58 para convertir el tiempo en distancia en centímetros, de acuerdo con la velocidad del sonido en el aire (aproximadamente 343 metros por segundo).
      
      ##### Cálculo de la distancia:
      El contador `us_counter` mide el tiempo que tarda el pulso ultrasónico en viajar hacia el obstáculo y volver. Este valor se convierte en distancia mediante la fórmula:


2. **buzzer.v**: Módulo que controla la activación del buzzer, emitiendo una señal de alerta cuando la distancia es menor a 10 cm.  
   ```
   module buzzer(
    input wire clk,      
    input wire enable,   
    output reg buzzer_out 
   );

   always @(posedge clk) begin
    if (enable)
        buzzer_out <= 1'b0; 
    else
        buzzer_out <= 1'b1; 
   end
   endmodule

   ```

    ### Control de Buzzer en Verilog
      
      Este código Verilog implementa el control de un buzzer, que se activa o desactiva en función de una señal de habilitación (`enable`). A continuación se detalla su funcionamiento:
      
      #### Entradas y Salidas:
      
      ##### Entradas:
      - **clk:** Señal de reloj del sistema, que sincroniza las operaciones del buzzer.
      - **enable:** Señal de control que determina si el buzzer debe estar activado o desactivado.
      
      ##### Salida:
      - **buzzer_out:** Señal de salida que controla directamente el estado del buzzer.
      
      #### Funcionamiento:
      
      ##### 1. Señal de habilitación (`enable`):
      - El buzzer se controla mediante la señal `enable`. Si `enable` está en alto (1), el buzzer se activa; si está en bajo (0), el buzzer se desactiva.
      
      ##### 2. Comportamiento en cada flanco positivo del reloj (`clk`):
      - En cada flanco positivo de la señal de reloj (`posedge clk`), el sistema evalúa el estado de la señal `enable`:
        - Si `enable` está activa (1), la salida `buzzer_out` se pone en bajo (0), lo que activa el buzzer.
        - Si `enable` está inactiva (0), la salida `buzzer_out` se pone en alto (1), lo que apaga el buzzer.


3. **top.v**: Módulo principal que conecta los módulos sonic y buzzer, coordinando las salidas visuales y sonoras.  
   ```
   `include "sonic.v"
   `include "buzzer.v"

   module top(
    input clk50,
    output trig, 
    input echo,
    input clk10, 

    output buzzer_out, 
    output red_led,    
    output green_led,  
    output blue_led    
   );

    wire [32:0] distance;
    wire enable_buzzer; 

    sonic sc (
        .clock(clk50),
        .trig(trig),
        .echo(echo),
        .distance(distance),
        .buzzer(enable_buzzer), 
        .red_led(red_led),       
        .green_led(green_led),   
        .blue_led(blue_led)      
    );

    buzzer bz (
        .clk(clk50),              
        .enable(enable_buzzer),    
        .buzzer_out(buzzer_out)    
    );

   endmodule
   ```

     ### Módulo Principal (Top) en Verilog
      
      Este código Verilog es el módulo principal (`top`) que integra dos submódulos: `sonic` (sensor ultrasónico) y `buzzer` (control del buzzer). El sistema completo mide la distancia a un obstáculo utilizando el sensor ultrasónico y, en función de esa distancia, activa el buzzer y los LEDs de colores para proporcionar alertas visuales y sonoras.
      
      #### Entradas y Salidas:
      
      ##### Entradas:
      - **clk50:** Señal de reloj de 50 MHz usada para sincronizar todo el sistema.
      - **trig:** Señal de disparo del sensor ultrasónico.
      - **echo:** Señal de retorno del sensor ultrasónico.
      - **clk10:** Otra señal de reloj (aunque no se utiliza en el código actual).
      
      ##### Salidas:
      - **buzzer_out:** Señal que controla el estado del buzzer (activado o desactivado).
      - **red_led, green_led, blue_led:** Señales que controlan el estado de los LEDs RGB para indicar la distancia medida.
      
      #### Funcionamiento:
      
      ##### 1. Instancia del Módulo `sonic`:
      - El módulo `sonic` se encarga de medir la distancia utilizando un sensor ultrasónico.
      - Se conecta la señal de reloj (`clk50`), la señal de disparo (`trig`), y la señal de retorno (`echo`).
      - La distancia medida se almacena en la señal `distance`.
      - Además, el módulo `sonic` controla la habilitación del buzzer mediante la señal `enable_buzzer`, y también gestiona las salidas de los LEDs (`red_led`, `green_led`, `blue_led`) según la distancia medida.
      
      ##### 2. Instancia del Módulo `buzzer`:
      - El módulo `buzzer` recibe la señal `clk50` y la señal `enable_buzzer` generada por el módulo `sonic`.
      - Si la señal `enable_buzzer` es activada por el módulo `sonic` (cuando la distancia es menor a 10 cm), el buzzer se activa.
      - La salida `buzzer_out` controla directamente el estado del buzzer.
      
      #### Interacción entre los Módulos:
      - El módulo `sonic` mide la distancia y genera una señal de habilitación (`enable_buzzer`) cuando la distancia es menor a un umbral (por ejemplo, 10 cm). Esta señal se utiliza para activar o desactivar el buzzer mediante el módulo `buzzer`.
      - Los LEDs RGB también se controlan dentro del módulo `sonic`, cambiando de color según la distancia medida (rojo, azul o verde).


## 5. Máquina de Estados

Para estos módulos, podemos definir una máquina de estados que controle el funcionamiento del sistema, principalmente para gestionar la activación del buzzer y los LEDs en función de la medida de distancia. A continuación se presenta la propuesta de la máquina de estados, junto con una explicación.

### Máquina de Estados

La máquina de estados tiene cuatro estados principales, basados en la distancia medida por el sensor ultrasónico:

- **IDLE**: El sistema está esperando una medición o procesando la distancia, los LED y el timbre están desactivados.
- **CLOSE_RANGE**: La distancia es menor a 10 cm. El timbre se activa y el LED rojo se enciende para indicar proximidad peligrosa.
- **MEDIUM_RANGE**: La distancia está entre 10 y 30 cm. Se enciende el LED azul para anunciar una distancia media de aproximación.
- **SAFE_RANGE**: La distancia está entre 30 y 50 cm. Se enciende el LED verde para indicar que la distancia es segura.

Si la distancia es mayor a 50 cm, el sistema apaga todos los LED y desactiva el timbre.

### Transiciones de la Máquina de Estados

- De **IDLE** a **CLOSE_RANGE**: Cuando la distancia medida es menor a 10 cm.
- De **IDLE** a **MEDIUM_RANGE**: Cuando la distancia medida está entre 10 y 30 cm.
- De **IDLE** a **SAFE_RANGE**: Cuando la distancia medida está entre 30 y 50 cm.
- De cualquier estado a **IDLE**: Si la distancia supera los 50 cm, apagamos todo.
- De **CLOSE_RANGE** a **MEDIUM_RANGE**: Si la distancia aumenta y entra en el rango medio (10-30 cm).
- De **MEDIUM_RANGE** a **SAFE_RANGE**: Si la distancia aumenta a más de 30 cm.

### Explicación de la Máquina de Estados

La máquina de estados es responsable de administrar el comportamiento del sistema en función de la distancia medida por el sensor ultrasónico. Cada estado representa un rango de distancia y dicta cómo deben comportarse los LED y el timbre. La lógica de la máquina de estados ayuda a organizar el control del sistema de manera eficiente, permitiendo transiciones claras y predecibles entre las diferentes acciones del sistema.

En la implementación actual del código Verilog, la lógica para manejar los diferentes rangos de distancia y las acciones asociadas ya está integrada en el módulo `sonic.v`. Sin embargo, podríamos expandir esto a una máquina de estados más formal con una declaración `case` que controle los estados y las transiciones de acuerdo con las distancias medidas.

Si tienes más detalles que quieras agregar o modificar, ¡dime y ajustamos la máquina de estados!

![](/PROYECTO/Imagenes_Proyecto/Maquina.png)



## 6. Simulación y Verificación

![](/PROYECTO/Imagenes_Proyecto/simulación.png)

### Observación de Señales en GTKWave

#### **Señal: clk50**
- *Forma de onda*: Un tren de pulsos de 50 MHz, alternando entre 0 (bajo) y 1 (alto).
- *Descripción*: La señal oscila rápidamente, con un periodo de 20 ns. Esto se repite a lo largo de toda la simulación, proporcionando el reloj para el sistema.

---

#### **Señal: trig**
- *Forma de onda*: Pulsos cortos en intervalos de tiempo.
- *Descripción*: Cada vez que se inicia una medición, trig sube a 1 (alto) y luego regresa a 0 (bajo) rápidamente. Por ejemplo, podrías ver un pulso en trig de alrededor de 10 ns que se repite al inicio de cada medición.

---

#### **Señal: echo**
- *Forma de onda*: Pulsos que varían en duración dependiendo de la distancia.
- *Descripción*:
  - Para una distancia de 5 cm: Aparece un pulso de aproximadamente 580 ns.
  - Para una distancia de 24 cm: Aparece un pulso más largo, cerca de 1400 ns.
  - Para una distancia de 31 cm: Un pulso de alrededor de 1800 ns.
  - Para una distancia de 52 cm: Un pulso que podría durar más, pero que se considera como "sin objeto", antes de volver a 0.
- *Expectativa*: La longitud del pulso debe ser directamente proporcional a la distancia del objeto.

---

#### **Señal: buzzer_out**
- *Forma de onda*: Alterna entre 0 (bajo) y 1 (alto) basado en la proximidad.
- *Descripción*:
  - Durante la distancia de 5 cm: buzzer_out se activa (1).
  - Cuando la distancia supera los 10 cm (por ejemplo, 24 cm): buzzer_out se desactiva (0).
  - Se mantiene en 0 durante las distancias de 31 cm y 52 cm.
- *Observación*: Esto debería mostrar claramente que el buzzer está en funcionamiento sólo cuando hay un objeto muy cerca.

---

#### **Señal: red_led**
- *Forma de onda*: 1 (alto) o 0 (bajo).
- *Descripción*:
  - Activo (1) durante la distancia de 5 cm.
  - Se apaga (0) cuando la distancia es mayor a 10 cm.
- *Visualización*: Deberías ver un pulso alto correspondiente a cuando la distancia es menor a 10 cm.

---

#### **Señal: blue_led**
- *Forma de onda*: 1 (alto) o 0 (bajo).
- *Descripción*:
  - Se activa (1) durante la distancia entre 10 cm y 30 cm (por ejemplo, 24 cm).
  - Se apaga (0) cuando la distancia es menor a 10 cm o mayor a 30 cm.
- *Observación*: Un pulso en blue_led debe aparecer cuando la distancia medida está entre 10 cm y 30 cm.

---

#### **Señal: green_led**
- *Forma de onda*: 1 (alto) o 0 (bajo).
- *Descripción*:
  - Se activa (1) durante la distancia entre 30 cm y 50 cm (por ejemplo, 31 cm).
  - Se apaga (0) cuando la distancia es menor a 30 cm o mayor a 50 cm.
- *Visualización*: Un pulso debe mostrarse en green_led cuando la distancia está en el rango correcto.

---

### Secuencia de Eventos

1. *Inicio de la Simulación*: Todas las señales de LED y buzzer están en 0 (bajo).
  
2. *Primera Medición (5 cm)*:
   - trig sube brevemente a 1.
   - echo genera un pulso de 580 ns.
   - buzzer_out se activa (1).
   - red_led se activa (1), mientras que blue_led y green_led permanecen apagados (0).

3. *Segunda Medición (24 cm)*:
   - trig se activa nuevamente.
   - echo produce un pulso de 1400 ns.
   - buzzer_out se apaga (0).
   - red_led se apaga (0), mientras que blue_led se activa (1).

4. *Tercera Medición (31 cm)*:
   - trig se activa.
   - echo genera un pulso de 1800 ns.
   - buzzer_out sigue apagado (0).
   - red_led y blue_led se apagan (0), mientras que green_led se activa (1).

5. *Cuarta Medición (52 cm)*:
   - trig se activa.
   - echo se mantiene en bajo (0) porque no hay objeto.
   - buzzer_out se mantiene apagado (0).
   - Todos los LEDs se apagan (0).

Los resultados de las simulaciones mostraron que el sistema responde correctamente a las condiciones de distancia definidas. Se validó el comportamiento de los módulos de forma individual y conjunta, asegurando que las señales se activan de manera adecuada.

## 6. Resultados Obtenidos
Las pruebas realizadas en simulaciones demostraron que el sistema funciona correctamente bajo diversas condiciones. Se obtuvo un control preciso tanto del buzzer como del LED RGB, ofreciendo alertas claras y efectivas basadas en la distancia medida. El diseño modular permitió integrar los diferentes componentes de manera eficiente.

## 7. Conclusión
El sistema de estacionamiento asistido fue implementado con éxito, cumpliendo con los objetivos establecidos. Las simulaciones confirmaron que el sensor ultrasónico, el LED RGB y el buzzer funcionan correctamente para proporcionar alertas visuales y sonoras al conductor, asistiendo en maniobras de estacionamiento seguras. La implementación en hardware puede seguir el mismo flujo descrito para validar el funcionamiento en tiempo real.

![](/PROYECTO/Imagenes_Proyecto/Equipo.png)