/*
    这次module定死了640*480 60Hz 
    在7020板子上进行了验证，可以正常输出640*480 60Hz的信号
    640*480 60Hz 
    电子枪扫描范围800*525  需要的clk 25.2MHz=800*525*60Hz

    不必纠结时序图中的h_back_proch等含义，只要在这段时间内不输出就行

    使用hcnt 0~799计数扫描一行的800个clk
    行同步脉冲的开始位置 hs_begin = 0 对应hcnt从0到1的时刻
    行同步脉冲的结束位置 hs_end = 96   hs低电平持续96个clk
    行数据开始输出的位置 hdata_begin = 96 + 40(h_back_proch) + 8(h_left_border) = 144
        即 97~144这48个clk为h_back_proch和h_left_border
    行数据停止输出的位置 hdata_end = 96 + 40 + 8 + 640 = 784  数据输出640个clk 145~784
    行同步信号的结束位置 和sync_end = 96 + 40 + 8 + 640 + 8 + 8 = 800(0)  对应hcnt从0到1的时刻
    hsync在0处和在800处是一样的，正好一个周期800个clk

    使用vcnt 0~524计数扫描一场的525行
    场同步脉冲的开始位置 vs_begin = 0 line
    场同步脉冲的结束位置 vs_end = 2 line
    场数据开始输出的位置 vdata_begin = 2 + 25 + 8
    场数据停止输出的位置 vdata_end = 2 + 25 + 8 + 480
    场同步信号的结束位置 vsync_end = 2 + 25 + 8 + 480 + 8 + 8 = 525(0)

*/

`include "vga_parameter.v"

module vga_ctrl (
    input             clk,
    input             reset_n,
    input      [11:0] data,
    output reg        data_request,  // 使vga_RGB和vga_BLK同步
    output reg [31:0] hcount,        // 行扫描位置X 0~639  对应屏幕上的坐标
    output reg [31:0] vcount,        // 场扫描位置Y 0~319
    output reg        vga_HS,        // 行同步信号
    output reg        vga_VS,        // 场同步信号
    output reg        vga_BLK,       // 数据输出时间段，在7020上验证时没有用到
    output reg [11:0] vga_RGB        // 每个颜色通道8位 高八位为R
);

    parameter hsync_end = `H_Total_Time;
    parameter hs_end = `H_Sync_Time;
    parameter vsync_end = `V_Total_Time;
    parameter vs_end = `V_Sync_Time;

    parameter hdata_begin = `H_Sync_Time + `H_Back_Porch + `H_Lefter_Border;
    parameter hdata_end = `H_Sync_Time + `H_Back_Porch + `H_Lefter_Border + `H_Data_Time;

    parameter vdata_begin = `V_Sync_Time + `V_Back_Porch + `V_Top_Border;
    parameter vdata_end = `V_Sync_Time + `V_Back_Porch + `V_Top_Border + `V_Data_Time;

    reg [31:0] hcnt;  // 计数0~799 行扫描计数器
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) hcnt <= 0;
        else if (hsync_end - 1 <= hcnt) hcnt <= 0;
        else hcnt <= hcnt + 1;
    end

    // hcnt和vga_HS都是时序控制，vga_HS赋值有一个延迟，在hcnt 1~96这96个clk内vga_HS为0
    always @(posedge clk) begin
        vga_HS <= (hcnt < hs_end) ? 0 : 1;
    end

    reg [31:0] vcnt;  // 场扫描计数器 0~524
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

    // 同理，vga_VS赋值有一个延迟，在vcnt 1~2这2个line内vga_VS为0
    always @(posedge clk) begin
        vga_VS <= (vcnt < vs_end) ? 0 : 1;
    end

    // 同理，仅考察行同步信号的情况，data_request在hcnt为hdata_begin ~ hdata_end-1 这640个clk内为1
    always @(posedge clk) begin
        data_request <= (hcnt >= hdata_begin - 1) &&
         (hcnt < hdata_end - 1) && (vcnt >= vdata_begin) && (vcnt <= vdata_end - 1);
    end

    // 推迟一个clk vga_BLK在hcnt为hdata_begin+1 ~ hdata_end 这640个clk内为1
    always @(posedge clk) begin
        vga_BLK <= data_request;
    end

    // 推迟一个clk vga_BLK在hcnt为hdata_begin+1 ~ hdata_end 这640个clk内为1
    always @(posedge clk) begin
        vga_RGB <= data_request ? data : 0;
    end

    always @(posedge clk) hcount <= data_request ? hcnt - hdata_begin : 0;

    always @(posedge clk) vcount <= data_request ? vcnt - vdata_begin : 0;

    /*
    常见问题：时序逻辑会导致vga_RGB比vga_BLK慢一拍
    添加data_request信号解决 
    技巧：设置data_request信号比145~784这个范围早一拍，因此vga_RGB在145~784这个范围内有效
    always @(posedge clk) begin
        vga_RGB <= vga_BLK ? data : 0;
    end
    */

endmodule
