module top_module(
    input [7:0] a, b, c, d,
    output [7:0] min
);

    wire [7:0] temp1, temp2;
    assign temp1 = (a < b) ? a : b;
    assign temp2 = (c < d) ? c : d;
    assign min = (temp1 < temp2) ? temp1 : temp2;


// 一个三选一 mux
/*
((sel[1:0] == 2'h0) ? a :     // A 3-to-1 mux
 (sel[1:0] == 2'h1) ? b :
                      c )
*/

endmodule