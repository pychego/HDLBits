`timescale 1ns/1ns

module shake_suppression_tb ();
    
    reg clk;
    reg reset_n;
    reg key_value;
    wire key_flag;
    wire filter_value;

    shake_suppression shake_suppression_inst(
        .clk(clk),
        .reset_n(reset_n),
        .key_value(key_value),
        .key_flag(key_flag),
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
        # 3000;

        key_value = 0;
        # 20000;
        key_value = 1;
        # 30000;
        key_value = 0;
        # 33000;
        key_value = 1;
        # 40000;
        key_value = 0;
        # 50_000_000;

        // 释放抖动
        key_value = 1;
        # 30000;
        key_value = 0;
        # 30000;
        key_value = 1;
        # 30000;
        key_value = 0;
        # 40000;
        key_value = 1;
        # 40_000_000;
        $stop;

    end

endmodule