# Informe de Laboratorio: Diseño y Simulación de un Circuito Lógico

## Objetivo:
El objetivo de este laboratorio es diseñar y simular un circuito lógico que implemente una función específica utilizando el lenguaje de descripción de hardware Verilog.

## Materiales:
- Herramientas de diseño y simulación de circuitos lógicos (por ejemplo, Verilog, un simulador de Verilog en este caso gtkwave).
- Archivo de diseño Verilog (.v) con la lógica del circuito.
- Archivo de testbench Verilog (.v) para simular y verificar el funcionamiento del circuito.

## Procedimiento:

### 1. Diseño del Circuito Lógico:
- Se utiliza un archivo de diseño en Verilog llamado "lab001.v" que contiene la lógica del circuito a implementar.
- El circuito a diseñar consta de entradas A, B y Ci, y produce las salidas S y Co según una función lógica específica.
- El diseño del circuito se realiza en el módulo `lab001`, donde se definen las entradas, salidas y las interconexiones lógicas necesarias para implementar la función deseada.

![](/Lab-digital-grupo-4/lab001/imagenes01/lab001.png)

### 2. Descripción del Testbench:
- Se crea un archivo de testbench en Verilog llamado "lab001tb.v" para simular el funcionamiento del circuito diseñado.
- En el testbench, se instancia el módulo del diseño (`lab001`) y se proporcionan los valores de entrada (`A_tb`, `B_tb` y `Ci_tb`) para evaluar el comportamiento del circuito.
- Se establecen los valores de entrada y se observan las salidas del circuito después de un cierto período de tiempo para verificar su correcto funcionamiento.

![](/Lab-digital-grupo-4/LAB001/imagenes01/1lab001.png)


### 3. Simulación del Circuito:
- Se ejecuta la simulación del circuito utilizando el testbench creado.
- Durante la simulación, se observan las formas de onda de las señales de entrada y salida del circuito.
- Se comprueba si las salidas del circuito coinciden con las expectativas de acuerdo con la función lógica especificada.

![](/Lab-digital-grupo-4/LAB001/imagenes01/2lab001.png)

### 4. Generación de Resultados:
- Se genera un archivo VCD (Value Change Dump) durante la simulación, que registra las señales de entrada y salida del circuito en cada ciclo de simulación.
- Este archivo VCD se utiliza para verificar el comportamiento del circuito y analizar su funcionamiento mediante herramientas de visualización de formas de onda.


## Resultados:
Los resultados obtenidos de la simulación del circuito se encuentran registrados en el archivo "lab001.vcd" generado durante la ejecución del testbench. Estos resultados pueden ser analizados visualmente utilizando herramientas de visualización de formas de onda para verificar el correcto funcionamiento del circuito. donde efectivamente vemos que cumple con las tabla de verdad.
![](/Lab-digital-grupo-4/LAB001/imagenes01/tablalab001.png)

