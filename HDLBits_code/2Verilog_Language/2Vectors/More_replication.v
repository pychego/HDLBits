module top_module (
    input wire a, b, c, d, e,
    output [24:0] out
);

    // wire [24:0] temp1;
    // wire [24:0] temp2;
    // assign temp1 = {{5{a}}, {5{b}}, {5{c}}, {5{d}}, {5{e}}};
    // assign temp2 = {5{{a, b, c, d, e}}};
    // assign out = ~temp1 ^ temp2;

    assign out = ~{{5{a}}, {5{b}}, {5{c}}, {5{d}}, {5{e}}} ^ {5{a, b, c, d, e}};

endmodule