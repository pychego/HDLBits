// 设计4个led灯以不同的频率闪烁
// 首先设计一个led闪烁的模块,再用参数化进行4个实例化即可
// 最简单的module,可以用来测试新板子的功能
module led_flash (
    input clock,
    input reset_n,
    output  reg led  // 底层模块定义变量类型
);
    parameter MCNT = 2500_0000;  // 闪烁周期为1s
    reg [31:0] count;
    
    // 操作计数周期
    always @(posedge clock or negedge reset_n) begin
        if(!reset_n) begin
            count <= 0;
        end else begin  // 满足clock上升沿时
            if(count == MCNT - 1) begin
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end
    end

    // led闪烁 
    always @(posedge clock or negedge reset_n) begin
        if(!reset_n) begin
            led <= 1'b0;
        end else begin
            if(count == MCNT - 1) begin
                led <= ~led;
            end
        end
    end
    
endmodule