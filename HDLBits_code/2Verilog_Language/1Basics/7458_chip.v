module top_module(
    input p1a, p2a, p2b, p2c, p2d,
    output p2y,
    input p1c, p1b, p1f, p1e, p1d,
    output p1y
);

    assign p2y = (p2a & p2b) | (p2c & p2d);
    assign p1y = (p1a & p1c & p1b) | (p1f & p1e & p1d);


endmodule