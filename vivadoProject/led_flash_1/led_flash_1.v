// 7010时钟周期20ns， 要求led灯闪烁周期为1s，所以led灯闪烁周期为50M个时钟周期
module led_flash (
    input Clock,
    input Reset_n,
    output reg Led
);
    // 500ms闪烁一次，需要25M(Million)个时钟周期 500_000_000 / 20 = 25_000_000
    // 25000000转化为二进制一共25位，因此需要25位的寄存器
    reg [24:0] count;

    parameter MCNT = 2500_0000;
    // 时序逻辑的标准写法
    always @(posedge Clock or negedge Reset_n) begin
        if (!Reset_n) begin 
            count <= 0;
        end // 假设4个clk反转一次，则在clk==3时就需要置零。因为clk刚==3时，clk已经过了，因此3也是一个完整周期
        else if (count ==  MCNT - 1) begin
                count <= 0;
            end else begin
                count <= count + 1;
            end
    end

    // 分开赋值count和Led
    always @(posedge Clock or negedge Reset_n) begin
        if (!Reset_n) begin
            Led <= 1'b0;
        end else if (count == MCNT - 1) begin
            // 如果没有复位信号，怎么却似那个led的初始值？
            Led <= ~Led;
        end
    end

endmodule