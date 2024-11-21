module top_module (
    input  a,
    input  b,
    input  c,
    output out
);

    // NAND 与非门
    wire temp; 
    andgate andgate_inst1(temp, a, b, c, 1, 1);

    assign out = ~temp;


endmodule
