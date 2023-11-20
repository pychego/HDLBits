/*
    在7020板子上进行了验证，可以正常输出640*480 60Hz的信号
    640*480 60Hz 
    电子枪扫描范围800*525  需要的clk 25.2MHz=800*525*60Hz

    使用hcnt 0~799计数扫描一行的800个clk
    行同步脉冲的开始位置 hs_begin = 0 对应hcnt从0到1的时刻
    行同步脉冲的结束位置 hs_end = 96   hs低电平持续96个clk
    行数据开始输出的位置 hdata_begin = 96 + 40(h_back_proch) + 8(h_left_border) = 144
    行数据停止输出的位置 hdata_end = 96 + 40 + 8 + 640 = 784
    行同步信号的结束位置 和sync_end = 96 + 40 + 8 + 640 + 8 + 8 = 800(0)  对应hcnt从0到1的时刻
    hsync在0处和在800处是一样的，正好一个周期800个clk

    使用vcnt 0~524计数扫描一场的525行
    场同步脉冲的开始位置 vs_begin = 0 line
    场同步脉冲的结束位置 vs_end = 2 line
    场数据开始输出的位置 vdata_begin = 2 + 25 + 8
    场数据停止输出的位置 vdata_end = 2 + 25 + 8 + 480
    场同步信号的结束位置 vsync_end = 2 + 25 + 8 + 480 + 8 + 8 = 525(0)




*/
module vga_ctrl (


    input             clk,
    input             reset_n,
    input      [11:0] data,
    output reg        data_request,  // 使vga_RGB和vga_BLK同步
    output reg [ 9:0] hcount,        // 行扫描位置X 0~639  对应屏幕上的坐标
    output reg [ 8:0] vcount,        // 场扫描位置Y 0~319
    output reg        vga_HS,
    output reg        vga_VS,
    output reg        vga_BLK,       // 数据输出时间段，在7020上验证时没有用到
    output reg [23:0] vga_RGB        // 每个颜色通道8位 高八位为R
);

    parameter hsync_end = 800;
    parameter hs_end = 96;
    parameter vsync_end = 525;
    parameter vs_end = 2;

    parameter hdata_begin = 144;
    parameter hdata_end = 784;

    parameter vdata_begin = 35;
    parameter vdata_end = 515;

    reg [9:0] hcnt;  // 能存放800个clk 行扫描计数器
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) hcnt <= 0;
        else if (hsync_end - 1 <= hcnt) hcnt <= 0;
        else hcnt <= hcnt + 1;
    end

    // hcnt和vga_HS都是时序控制，vga_HS赋值有一个延迟，在hcnt 1~96这96个clk内vga_HS为0
    always @(posedge clk) begin
        vga_HS <= (hcnt < hs_end) ? 0 : 1;
    end

    reg [9:0] vcnt;  // 场扫描计数器 0~524
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) vcnt <= 0;
        else if (hsync_end - 1 <= hcnt) begin
            if (vsync_end - 1 <= vcnt) begin
                vcnt <= 0;
            end else begin
                vcnt <= vcnt + 1;
            end
        end
    end

    always @(posedge clk) begin
        vga_VS <= (vcnt < vs_end) ? 0 : 1;
    end

    always @(posedge clk) begin
        data_request <= (hcnt >= hdata_begin - 1) &&
         (hcnt < hdata_end - 1) && (vcnt >= vdata_begin) && (vcnt <= vdata_end - 1);
    end

    always @(posedge clk) begin
        vga_BLK <= data_request;
    end

    always @(posedge clk) begin
        vga_RGB <= data_request ? data : 0;
    end

    always @(posedge clk) hcount <= data_request ? hcnt - hdata_begin : 0;

    always @(posedge clk) vcount <= data_request ? vcnt - vdata_begin : 0;






    /*
    // 常见问题：时序逻辑会导致vga_RGB比vga_BLK慢一拍
    // 添加data_request信号解决
    always @(posedge clk) begin
        vga_RGB <= vga_BLK ? data : 0;
    end
    */



endmodule
