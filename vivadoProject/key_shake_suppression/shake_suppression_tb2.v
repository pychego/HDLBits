`timescale 1ns/1ns

module shake_suppression_tb ();
    
    reg clk;
    reg reset_n;
    reg key_value;
    wire key_flag;
    reg [31:0] rand;
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

        press_key(2);
        
        $stop;

    end

    task press_key(input [31:0] seed);
        begin
            key_value = 1;
            #20_000_000;

            repeat(10) begin
                // 是取余数，不是除法，得到rand = 0~9999999
                rand = {$random(seed)} % 10_000_000;  
                #rand key_value = ~key_value;
            end
            key_value = 0;
            #40_000_000;

            repeat(10) begin
                rand = {$random(seed)} % 10_000_000;
                #rand key_value = ~key_value;
            end
            key_value = 1;
            #40_000_000;
        end

    endtask

endmodule