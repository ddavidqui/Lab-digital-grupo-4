
module lab001(
input A,
input B,
input Ci,
output S,
output Co

);

wire xor_1;
wire and_1;
wire and_2;

assign xor_1 = A^B;
assign and_1 = A&B;
assign and_2 = xor_1 & Ci;

assign S = xor_1 ^Ci;
assign Co = and_1 | and_2;

endmodule
