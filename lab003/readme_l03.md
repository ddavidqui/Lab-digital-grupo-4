# Informe del Laboratorio: Visualización en Pantalla de 7 Segmentos

## Introducción
En este laboratorio se trabajará con una FPGA (Field Programmable Gate Array) y una pantalla de 7 segmentos para visualizar números en diferentes formatos. La práctica se divide en dos partes: en la primera parte se visualizarán números en formato hexadecimal (del 0 al F) y se modificará el código para visualizar solo los números del 0 al 9. En la segunda parte se visualizará la suma de dos números de 3 bits tanto en formato hexadecimal como decimal. El objetivo es aprender a diseñar y simular circuitos digitales utilizando VHDL/Verilog y comprender el funcionamiento de una pantalla de 7 segmentos.

> Nota: En ambas partes del proyecto, presentamos el funcionamiento en una FPGA en clase, siguiendo las indicaciones del profesor, por lo que no se envió video.

## Primera Parte: Visualización de Números en Formato Hexadecimal

### Objetivo
Lograr visualizar en una pantalla de 7 segmentos los números del 0 al F en formato hexadecimal y posteriormente modificar el código para visualizar solo los números del 0 al 9.

### Procedimiento

#### Números del 0 al F

**Conversión de Binario a Hexadecimal:**
Lo primero que realizamos fue pasar el código del conversor de binario a hexadecimal lo copiamos en Visual Studio:
![](/lab003/Imagenes_Lab003/1.png)

**Creación del Test Bench para Simulación en GTKWave:**
Creamos el test bench para simularlo en GTKWave:
![](/lab003/Imagenes_Lab003/2.png)
![](/lab003/Imagenes_Lab003/3.png)

**Simulación en GTKWave:**
Corremos nuestros códigos en GTKWave.
![](/lab003/Imagenes_Lab003/4.png)

#### Números del 0 al 9

**Modificación del Código para Mostrar Solo Números del 0 al 9:**
El mismo código del conversor anterior lo usamos lo único que hacemos es comentar los casos para los valores de A a F dejando solo los del 0 al 9:
![](/lab003/Imagenes_Lab003/5.png)

**Uso del Mismo Test Bench:**
Podemos usar el mismo test bench ya que nuestro código del conversor tiene un default que hace que nos sirva.

**Simulación en GTKWave:**
Corremos nuestros códigos en GTKWave.
![](/lab003/Imagenes_Lab003/6.png)

## Segunda Parte: Visualización de la Suma de Dos Números de 3 Bits

### Objetivo
Lograr visualizar en una pantalla de 7 segmentos la suma de dos números de 3 bits ingresados mediante los switches de la FPGA tanto en formato hexadecimal como en formato decimal.

### Procedimiento

**Modificación del Código del Sumador:**
Lo primero que hicimos fue reciclar el código del laboratorio anterior que era un sumador de 4 bits y lo convertimos en uno de 3 bits.
![](/lab003/Imagenes_Lab003/7.png)
![](/lab003/Imagenes_Lab003/8.png)

**Conexión con el Conversor de Binario a Hexadecimal:**
Luego conectamos con un top model la salida del sumador a nuestro conversor de binario a hexadecimal.
![](/lab003/Imagenes_Lab003/9.png)

**Creación y Simulación del Test Bench:**
Creamos nuestro test bench y lo simulamos en GTKWave.
![](/lab003/Imagenes_Lab003/10.png)
![](/lab003/Imagenes_Lab003/11.png)
![](/lab003/Imagenes_Lab003/12.png)
![](/lab003/Imagenes_Lab003/13.png)
