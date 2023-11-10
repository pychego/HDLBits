`timescale 1ns / 1ns

module counter_time_tb ();
    
    reg clk;
    reg reset_n;
    wire  [31:0] disp_data;

    counter_time counter_time_inst (
        .clk(clk),
        .reset_n(reset_n),
        .disp_data(disp_data)
    );

    initial clk = 0;
    always #10 clk = ~clk;

    initial begin
        reset_n = 0;
        #101 reset_n = 1;

        # 7_000_000_00;
        $stop;
    end

endmodule