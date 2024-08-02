

module sum3b(a, b, ci, s, co);

input [2:0] a;
input [2:0] b;
input ci;
output [2:0] s;
output co;

wire C1, C2;

lab001 sum0 (.A(a[0]), .B(b[0]), .Ci(1'b0), .S(s[0]), .Co(C1));
lab001 sum1 (.A(a[1]), .B(b[1]), .Ci(C1), .S(s[1]), .Co(C2));
lab001 sum2 (.A(a[2]), .B(b[2]), .Ci(C2), .S(s[2]), .Co(co));

endmodule
