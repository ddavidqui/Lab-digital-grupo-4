
module top_module (
    input [2:0] a,   // Operando a
    input [2:0] b,   // Operando b
    input ci,        // Acarreo de entrada
    output [0:6] SSeg,  // Salida para el display de 7 segmentos
    output [3:0] an,    // Salida para los ánodos del display
    output co          // Acarreo de salida
);

  wire [3:0] sum; // Resultado de la suma (4 bits para manejar el acarreo)
  wire c_out;    // Acarreo de salida del sumador

  // Instanciar el sumador de 3 bits
  sum3b sumador (
    .a(a),
    .b(b),
    .ci(ci),
    .s(sum[2:0]), // Los 3 bits menos significativos de la suma
    .co(c_out)
  );

  // El bit más significativo del resultado de la suma es el acarreo de salida
  assign sum[3] = c_out;

  // Instanciar el conversor de BCD a 7 segmentos
  BCDtoSSeg conversor (
    .BCD(sum),   // Entrar los 4 bits del resultado de la suma
    .SSeg(SSeg), // Salida para el display de 7 segmentos
    .an(an)      // Salida para los ánodos del display
  );

endmodule
