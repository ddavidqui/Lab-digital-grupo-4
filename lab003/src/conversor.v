module BCDtoSSeg (BCD, SSeg, an);

  input [3:0] BCD;
  output reg [0:6] SSeg;
  output [3:0] an;
  
  assign an = 4'b1110; // Solo un dígito activo (anodo común)

  always @(*) begin
    case (BCD)
      4'h0: SSeg = 7'b0000001; // "0"
      4'h1: SSeg = 7'b1001111; // "1"
      4'h2: SSeg = 7'b0010010; // "2"
      4'h3: SSeg = 7'b0000110; // "3"
      4'h4: SSeg = 7'b1001100; // "4"
      4'h5: SSeg = 7'b0100100; // "5"
      4'h6: SSeg = 7'b0100000; // "6"
      4'h7: SSeg = 7'b0001111; // "7"
      4'h8: SSeg = 7'b0000000; // "8"
      4'h9: SSeg = 7'b0000100; // "9"
      4'ha: SSeg = 7'b0001000; // "A"
      4'hb: SSeg = 7'b1100000; // "B"
      4'hc: SSeg = 7'b0110001; // "C"
      4'hd: SSeg = 7'b1000010; // "D"
      4'he: SSeg = 7'b0110000; // "E"
      4'hf: SSeg = 7'b0111000; // "F"
      default: SSeg = 7'b1111111; // Apagar todos los segmentos en caso de valor inválido
    endcase
  end

endmodule
