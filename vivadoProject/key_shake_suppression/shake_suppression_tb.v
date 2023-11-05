`timescale 1ns/1ns

module shake_suppression_tb ();
    
    reg clk;
    reg reset_n;
    reg key_value;
    wire filter_value;

    shake_suppression shake_suppression_inst(
        .clk(clk),
        .reset_n(reset_n),
        .key_value(key_value),
        .filter_value(filter_value)
    );

    // 信号激励
    initial clk = 1;
    always #10 clk = ~clk;

    initial begin
        reset_n = 0;
        key_value = 1;
        # 201;
        
        reset_n = 1;

        # 100;
        key_value = 0;
        # 1000;
        key_value = 1;
        # 2000;
        key_value = 0;
        # 3000;
        key_value = 1;
        # 4000;
        key_value = 0;
        # 20_000_001;

        key_value = 1;
        # 1000;
        key_value = 0;
        # 2000;
        key_value = 1;
        # 3000;
        key_value = 0;
        # 4000;
        key_value = 1;
        # 40_000_000;
        $stop;

    end

endmodule