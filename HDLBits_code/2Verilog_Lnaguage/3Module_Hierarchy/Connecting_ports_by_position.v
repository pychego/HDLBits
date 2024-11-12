module top_module(
    input a, b, c, d,
    output out1, out2
);

    mod_a mod_a_inst(
        out1,
        out2, 
        a, 
        b,
        c,
        d
    );

endmodule