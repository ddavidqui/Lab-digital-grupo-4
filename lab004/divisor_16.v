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

