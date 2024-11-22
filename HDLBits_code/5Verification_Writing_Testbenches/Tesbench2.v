module top_module();

    reg [7:0] clk;
    reg in;
    reg [2:0] s;
    reg out;

    initial begin
        clk = 0;
        in = 0;
        s = 2;
        #10 s = 6;
        #10 in = 1;
        s = 2;
        #10 in = 0;
        s = 7;
        #10 in = 1;
        s = 0;
        #30 in = 0;

    end

    always #5 clk = ~clk;

    q7 q7_inst_0(clk, in, s, out);



endmodule