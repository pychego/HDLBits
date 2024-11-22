module top_module();

    reg clk, reset, t, q;

    initial begin
        clk = 0;
        reset = 1;
        t = 0;
        #11 reset = 0;
        t = 1;
        #8 t = 0;
    end

    always #5 clk = ~clk;

    tff tff_inst_0(clk, reset, t, q);


endmodule