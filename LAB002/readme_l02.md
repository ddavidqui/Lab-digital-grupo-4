# Introducción

En este informe, se presenta el procedimiento llevado a cabo para la realización de un sumador de 4 bits utilizando el software Quartus. El objetivo principal de este laboratorio es comprender y aplicar los conceptos de diseño de circuitos digitales, así como familiarizarse con el entorno de desarrollo Quartus.

Un sumador de 4 bits es un circuito lógico que realiza la operación de suma binaria en números de 4 bits. Este tipo de circuito es esencial en numerosas aplicaciones, desde la aritmética básica hasta la implementación de procesadores y sistemas de cómputo complejos.

El informe detalla el proceso desde la concepción del diseño hasta la simulación y verificación funcional del circuito en Quartus. Se presentan capturas de pantalla y explicaciones paso a paso para facilitar la comprensión del procedimiento llevado a cabo. Al finalizar, se ofrece una evaluación del funcionamiento del sumador de 4 bits.

# Diseño del Circuito

![](/LAB002/Imagenes_Lab002/1.png)

En el diseño de circuitos digitales, es común utilizar la modularidad para simplificar la implementación de circuitos más complejos. Un sumador de 1 bit es el bloque básico que se utiliza para construir sumadores de mayor tamaño, como un sumador de 4 bits. La belleza de esta técnica radica en su simplicidad y eficiencia.

Un sumador de 1 bit es un circuito que toma dos bits de entrada y produce una suma de un bit y un acarreo (carry-out). Al unir cuatro sumadores de 1 bit, podemos construir un sumador de 4 bits. En este enfoque, cada sumador de 1 bit se encarga de sumar un par de bits correspondientes de los números de entrada, mientras que los acarreos se propagan de un sumador al siguiente.

Este concepto se refleja directamente en el código de Quartus. Al diseñar un sumador de 4 bits en Quartus, simplemente necesitamos replicar el diseño del sumador de 1 bit cuatro veces y conectar correctamente las entradas y salidas. Quartus nos permite crear instancias de módulos y conectarlas entre sí de manera eficiente, lo que facilita enormemente la implementación de circuitos complejos a partir de componentes simples.

En el código de Quartus, cada sumador de 1 bit se representaría como un módulo o una función que toma dos bits de entrada y produce una suma de un bit y un acarreo. Luego, estas instancias se instanciarían cuatro veces y se conectarían apropiadamente para formar el sumador de 4 bits. El código resultante es limpio, modular y fácil de entender, lo que facilita el diseño y la depuración del circuito.


![](/LAB002/Imagenes_Lab002/2.png)


# Creación del Proyecto en Quartus

- Creamos una carpeta con el nombre "sum2b" donde almacenaremos todos los archivos relacionados con nuestro proyecto, incluyendo el archivo "sum1b.v" que será instanciado más adelante.


![](/LAB002/Imagenes_Lab002/3.jpg)


- Abrimos Quartus y creamos un nuevo proyecto en la carpeta "sum4b".
- Una vez creado el proyecto, configuramos la FPGA seleccionada dentro de Quartus.

![](/LAB002/Imagenes_Lab002/4.jpg)

- Creamos un nuevo archivo Verilog dentro del proyecto en Quartus.

![](/LAB002/Imagenes_Lab002/5.jpg)



- En ese archivo Verilog es donde vamos a escribir el código de nuestro sumador de 4 bits.

![](/LAB002/Imagenes_Lab002/6.jpg)

- Al terminar de escribirlo le damos en la opción “Start Analysis & Elaboration” para comprobar que no salga ningún error.

![](/LAB002/Imagenes_Lab002/7.jpg)

- Asignamos cada entrada y salida del diseño Verilog a los pines específicos de la FPGA en la opción “Pin Planer”, en la columna “Location” se podrá seleccionar los pines de la FPGA asociados a ciertos elementos, en este caso, se van a usar switchs para las entradas y leds para las salidas, dicha numeración se podrá observar directamente en la FPGA.

![](/LAB002/Imagenes_Lab002/8.jpg)

![](/LAB002/Imagenes_Lab002/9.jpg)

- Al terminar de asignar cada pin con su respectiva entrada o salida, le damos de nuevo en la opción “Run I/O Assignment Analysis” para asegurarnos de que no salga ningún error.

![](/LAB002/Imagenes_Lab002/10.jpg)

- Abrimos la ventana Programmer en Quartus.

![](/LAB002/Imagenes_Lab002/11.jpg)

- En la ventana Programmer le dimos clic al botón Hardware Setup que abrió usa sub ventana en donde seleccionamos el USB-blaster de la FPGA como se muestra en la imagen.

![](/LAB002/Imagenes_Lab002/12.png)

- Finalmente, en la ventana Programmer le dimos clic al botón Start que inició la programación de la FPGA.

![](/LAB002/Imagenes_Lab002/13.png)

- Una vez finalizada la programación, conectamos la FPGA a la computadora.
- Realizamos pruebas para verificar que el sumador de 4 bits funcione correctamente.
# Video de funcionamiento en la FPGA
https://youtu.be/V6SwwRPSi0w?si=3nxMFMWkOmhUfmJv

# CREACIÓN DE TESTBENCH PARA LA SIMULACIÓN



- `include "LAB002.v"`: Esta línea incluye el archivo LAB002.v, que contiene la lógica general que se va a probar.
- `module sum4b_tb();`: Define un módulo llamado sum4b_tb, que sirve como testbench para el módulo sum4b.
- `reg [3:0] a_tb;`, `reg [3:0] b_tb;`, `reg ci_tb;`: Estos son registros que representan las entradas del módulo sum4b_tb. `a_tb` y `b_tb` son buses de 4 bits que representan las entradas `a` y `b`, respectivamente, y `ci_tb` es un solo bit que representa la entrada de acarreo `ci`.
- `wire [3:0] s_tb;`, `wire co_tb;`: Estos son cables que representan las salidas del módulo sum4b_tb. `s_tb` es un bus de 4 bits que representa la salida `s`, y `co_tb` es un solo bit que representa la salida de acarreo `co`.
- `sum4b uut (.a(a_tb), .b(b_tb), .ci(ci_tb), .s(s_tb), .co(co_tb));`: Aquí se instancia el módulo sum4b dentro del testbench. Se conectan las entradas y salidas del módulo con los registros y cables definidos anteriormente.
- `initial begin`: Aquí comienza el bloque de inicialización. En este bloque se establecen los valores iniciales de las entradas y se definen los casos de prueba.
  - Dentro del bloque `initial begin`, se establecen varios casos de prueba para las entradas `a_tb`, `b_tb` y `ci_tb`. Para cada caso de prueba, se asignan valores a las entradas y se espera un cierto período de tiempo (`#10`) antes de pasar al siguiente caso de prueba.
- `initial begin`: Aquí comienza otro bloque `initial begin`, donde se establece la configuración para guardar la simulación en un archivo VCD (`sum4b_tb.vcd`) utilizando las funciones `$dumpfile` y `$dumpvars`.
- `#240 $finish;`: En este bloque `initial begin`, después de guardar la simulación en el archivo VCD, se finaliza la simulación después de 240 unidades de tiempo.

# A continuación se explicará los resultados de la simulación en 6 casos en especifico:

![](/LAB002/Imagenes_Lab002/simulacion.png)


# Sumas Binarias en un Bus de 4 bits

A continuación, se muestran varias sumas en binario realizadas en un bus de 4 bits, junto con sus resultados correspondientes:

## 1. Primer caso:
   
   0 + 0:
    
    0000  (0 en binario)  
    0000  (0 en binario)
  -------
    0000  (0 en binario)
    
   En esta suma, ambos operandos son 0, por lo que el resultado también es 0.

## 2. Segundo caso:
   
    2 + 2:
    
    0010  (2 en binario)  
    0010  (2 en binario)
  -------
    0100  (4 en binario)
    
   La suma de 2 en binario más 2 en binario es 4 en decimal y es lo que muestra la salida.

## 3. Tercer caso:
  
   6 + 6:
    
    0110  (6 en binario)  
    0110  (6 en binario)
  -------
    1100  (12 en binario)
    
   La suma de 6 en binario más 6 en binario es 12 en decimal y es lo que muestra la salida.

**AQUÍ COMENZAMOS UTILIZANDO EL ACARREO YA QUE TENEMOS UN BUS DE 4 BIT, ENTONCES VEREMOS UN 1 EN EL ACARREO REPRESENTANDO EL MÁS SIGNIFICATIVO**

## 4. Cuarto caso:
  
   8 + 8:
    
    1000  (8 en binario)  
    1000  (8 en binario)
  -------
 1 0000  (16 en binario)
    
   La suma de 8 en binario más 8 en binario es 16 en decimal, pero solo conservamos los últimos 4 bits, lo que nos da "0000" en binario y 0 en decimal y es lo que veremos en la salida.

## 5. Quinto caso:
  
   12 + 12:
    
    1100  (12 en binario)  
    1100  (12 en binario)
  -------
1 1000  (24 en binario)
    
   La suma de 12 en binario más 12 en binario es 24 en decimal, pero solo conservamos los últimos 4 bits, lo que nos da "1000" en binario y 8 en decimal que irá en la salida.

## 6. Sexto caso:
  
   15 + 15:
    
    1111  (15 en binario)  
    1111  (15 en binario)
  -------
1 1110  (30 en binario)
    
   La suma de 15 en binario más 15 en binario es 30 en binario, pero solo conservamos los últimos 4 bits, lo que nos da "1110" en binario que sería 14 en decimal.

Estas son las sumas en binario y sus resultados correspondientes cuando se utiliza un bus de 4 bits.



