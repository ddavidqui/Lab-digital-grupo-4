module contador(
    input clk_div,       // Señal de reloj dividido
    input reset,         // Señal de reinicio
    output reg [3:0] bcd0, // Salida BCD del dígito menos significativo (unidad)
    output reg [3:0] bcd1, // Salida BCD del siguiente dígito (decena)
    output reg [3:0] bcd2, // Salida BCD del siguiente dígito (centena)
    output reg [3:0] bcd3  // Salida BCD del dígito más significativo (mil)
);

    always @(posedge clk_div or negedge reset) begin
        if (reset==0) begin
            bcd0 <= 4'd0;
            bcd1 <= 4'd0;
            bcd2 <= 4'd0;
            bcd3 <= 4'd0;
        end else begin
            if (bcd0 == 4'd9) begin
                bcd0 <= 4'd0;
                if (bcd1 == 4'd9) begin
                    bcd1 <= 4'd0;
                    if (bcd2 == 4'd9) begin
                        bcd2 <= 4'd0;
                        if (bcd3 == 4'd9) begin
                            bcd3 <= 4'd0;
                        end else begin
                            bcd3 <= bcd3 + 1;
                        end
                    end else begin
                        bcd2 <= bcd2 + 1;
                    end
                end else begin
                    bcd1 <= bcd1 + 1;
                end
            end else begin
                bcd0 <= bcd0 + 1;
            end
        end
    end
endmodule

