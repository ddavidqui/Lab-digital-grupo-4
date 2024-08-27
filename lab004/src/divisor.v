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

