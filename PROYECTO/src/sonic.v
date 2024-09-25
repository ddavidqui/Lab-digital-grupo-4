module sonic(
    input clock,
    output trig,
    input echo,
    output reg [32:0] distance,
    output reg buzzer, // Salida para el buzzer
    output reg red_led, // Salida para el LED rojo
    output reg green_led, // Salida para el LED verde
    output reg blue_led // Salida para el LED azul
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
            distance <= us_counter / 58; // Convertir tiempo a distancia
            us_counter <= 0;

            // Control del buzzer
            if (distance < 10)
                buzzer <= 1'b1; // Activa el buzzer
            else
                buzzer <= 1'b0; // Desactiva el buzzer
            
            // Control del LED RGB
            if (distance < 10) begin
                red_led <= 1'b0;   // Enciende el rojo
                blue_led <= 1'b1;  // Apaga el azul
                green_led <= 1'b1; // Apaga el verde
            end
            else if (distance >= 10 && distance < 30) begin
                red_led <= 1'b1;   // Apaga el rojo
                blue_led <= 1'b1;  // Enciende el azul
                green_led <= 1'b0; // Apaga el verde
            end
            else if (distance >= 30 && distance <= 50) begin
                red_led <= 1'b1;   // Apaga el rojo
                blue_led <= 1'b0;  // Apaga el azul
                green_led <= 1'b1; // Enciende el verde
            end
            else begin
                red_led <= 1'b1;   // Apaga todos los LEDs si la distancia es mayor a 50
                blue_led <= 1'b1;
                green_led <= 1'b1;
            end
        end
    end
    
    if (forty_ms)
        _trig <= 1'b1;
end

endmodule


