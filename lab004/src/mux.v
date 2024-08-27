module seven_segment_mux(
    input wire [3:0] bcd0, bcd1, bcd2, bcd3,
    input wire [1:0] select,  // Selección para alternar entre los dígitos
    output reg [3:0] digit
);

    always @(*) begin
        case(select)
            2'b00: digit = bcd0;
            2'b01: digit = bcd1;
            2'b10: digit = bcd2;
            2'b11: digit = bcd3;
            default: digit = 4'b0000;
        endcase
    end
endmodule

