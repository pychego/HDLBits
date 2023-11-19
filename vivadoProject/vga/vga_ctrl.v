// 640*480
module vga_ctrl (
    input             clk,
    input             reset_n,
    output reg        vga_HS,
    output reg        vga_VS,
    output reg        vga_BLK,  // 数据输出时间段
    output reg [23:0] vga_RGB   // 每个颜色通道8位 高八位为R
);

    parameter hsync_end = 800;
    parameter hs_end = 96;
    parameter vsync_end = 525;
    parameter vs_end = 2;

    parameter hdata_begin = 144;
    parameter hdata_end = 784;

    parameter vdata_begin = 35;
    parameter vdata_end = 515;

    reg [9:0] hcnt;  // 能存放800个clk
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) hcnt <= 0;
        else if (hsync_end - 1 <= hcnt) hcnt <= 0;
        else hcnt <= hcnt + 1;
    end

    always @(posedge clk) begin
        vga_HS <= (hcnt < hs_end - 1) ? 0 : 1;
    end

    reg [9:0] vcnt;
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
        vga_VS <= (vcnt < vs_end - 1) ? 0 : 1;
    end

    always @(posedge clk) begin
        vga_BLK <= (hcnt >= hdata_begin - 1) &&
         (hcnt < hdata_end - 1) && (vcnt >= vdata_begin - 1) && (vcnt <= vdata_end - 1);
    end


    always @(posedge clk) begin
        vga_RGB <= vga_BLK ? 24'hffffff : 0;
    end



endmodule
