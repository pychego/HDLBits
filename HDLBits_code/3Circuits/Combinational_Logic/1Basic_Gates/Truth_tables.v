module top_module(
    input x3, x2, x1,
    output f
);

    assign f = ((~x3)&x2)|(x1&x3); 


endmodule