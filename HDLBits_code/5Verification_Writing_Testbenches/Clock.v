module top_module();


    reg clk;


    initial begin
        clk = 0;
    end

    always #5 clk = ~clk;

    dut dut_inst_0(clk);



endmodule