 `timescale 1ns/1ns

 module led_flash_tb #();

    // 定义信号,模块输入定义为reg
    reg Clock, Reset_n;
    wire Led;  // 模块输出定义为wire

    // 实例化模块
    led_flash led_flash(
        .Clock(Clock),
        .Reset_n(Reset_n),
        .Led(Led)
    );
 
    // 激励信号
    initial begin
        Clock = 1'b0;
    end

    always #10 Clock = ~Clock; // 周期为20ns

    initial begin
        Reset_n = 1'b0;
        #201 Reset_n = 1'b1;
    end

    

    
 endmodule