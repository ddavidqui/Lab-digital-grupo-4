module seven_segment_display(
    input [3:0] digit,
    output reg [6:0] seg
);

    always @(*) begin
        case(digit)
								 //abcdefg				
            4'd0: seg = 7'b0000001; // 0
            4'd1: seg = 7'b1001111; // 1
            4'd2: seg = 7'b0010010; // 2
            4'd3: seg = 7'b0000110; // 3
            4'd4: seg = 7'b1001100; // 4
            4'd5: seg = 7'b0100100; // 5
            4'd6: seg = 7'b1100000; // 6
            4'd7: seg = 7'b0001111; // 7
            4'd8: seg = 7'b0000000; // 8
            4'd9: seg = 7'b0001100; // 9
            default: seg = 7'b0000000; // Default (apagado)
        endcase
    end

endmodule

