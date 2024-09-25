module buzzer(
    input wire clk,      // Reloj del sistema
    input wire enable,   // Señal para activar el buzzer
    output reg buzzer_out // Salida para el buzzer
);

always @(posedge clk) begin
    if (enable)
        buzzer_out <= 1'b0; // Activa el buzzer
    else
        buzzer_out <= 1'b1; // Desactiva el buzzer
end

endmodule

