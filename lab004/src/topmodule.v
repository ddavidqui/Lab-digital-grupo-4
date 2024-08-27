//`include "divisor.v"
//`include "divisor_16.v"
//`include "contador.v"
//`include "mux.v"
//`include "conversor.v"

module top_module(
    input wire clk,        // Reloj principal (por ejemplo, 50 MHz)
    input wire reset,      // Señal de reinicio
    input wire sw1,        // Switch para seleccionar la escala de tiempo
    input wire sw2,        // Segundo switch para seleccionar la escala de tiempo
    output wire [6:0] seg, // Salida para el display de 7 segmentos
    output wire [3:0] an   // Salida para seleccionar el dígito activo
);

    // Señales internas
    wire clk_div_1Hz, clk_div_10Hz, clk_div_100Hz, clk_div_1kHz, clk_div_16ms;
    wire [3:0] bcd0, bcd1, bcd2, bcd3;
    wire [3:0] digit;
    reg [1:0] mux_select;
    reg clk_div_selected;

    // Instancias de los divisores de reloj
    clock_divider #(25000000) clk_div_1Hz_inst ( // 1 Hz
        .clk(clk),
        .reset(reset),
        .clk_div(clk_div_1Hz)
    );

    clock_divider #(2500000) clk_div_10Hz_inst ( // 10 Hz
        .clk(clk),
        .reset(reset),
        .clk_div(clk_div_10Hz)
    );

    clock_divider #(250000) clk_div_100Hz_inst ( // 100 Hz
        .clk(clk),
        .reset(reset),
        .clk_div(clk_div_100Hz)
    );

    clock_divider #(25000) clk_div_1kHz_inst ( // 1 kHz
        .clk(clk),
        .reset(reset),
        .clk_div(clk_div_1kHz)
    );

    clock_divider_16ms clk_div_16ms_inst (
        .clk(clk),
        .reset(reset),
        .clk_div(clk_div_16ms)
    );

    // Multiplexor para seleccionar el reloj basado en los switches
    always @(*) begin
        case ({sw1, sw2})
            2'b00: clk_div_selected = clk_div_1Hz;     // Segundos
            2'b01: clk_div_selected = clk_div_10Hz;    // Décimas
            2'b10: clk_div_selected = clk_div_100Hz;   // Centésimas
            2'b11: clk_div_selected = clk_div_1kHz;    // Milésimas
            default: clk_div_selected = clk_div_1Hz;
        endcase
    end

    // Instancia del contador
    contador contador_inst (
        .clk_div(clk_div_selected),
        .reset(reset),
        .bcd0(bcd0),
        .bcd1(bcd1),
        .bcd2(bcd2),
        .bcd3(bcd3)
    );

    // Módulo multiplexor para seleccionar el dígito activo
    seven_segment_mux mux_inst (
        .bcd0(bcd0),
        .bcd1(bcd1),
        .bcd2(bcd2),
        .bcd3(bcd3),
        .select(mux_select),
        .digit(digit)
    );

    // Decodificador de siete segmentos
    seven_segment_display display_inst (
        .digit(digit),
        .seg(seg)
    );

    // Control de la señal de selección
    always @(posedge clk_div_16ms or negedge reset) begin
        if (reset==0) begin
            mux_select <= 2'b00;
        end else begin
            mux_select <= mux_select + 1;
        end
    end

    // Control de los ánodos para seleccionar el dígito activo
    assign an = ~(4'b0001 << mux_select);  // Selección de dígito activa baja

endmodule

