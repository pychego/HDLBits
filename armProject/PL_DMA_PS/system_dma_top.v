`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/24 00:27:58
// Design Name: 
// Module Name: system_dma_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module system_dma_top (
    inout [14:0] DDR_addr,
    inout [ 2:0] DDR_ba,
    inout        DDR_cas_n,
    inout        DDR_ck_n,
    inout        DDR_ck_p,
    inout        DDR_cke,
    inout        DDR_cs_n,
    inout [ 3:0] DDR_dm,
    inout [31:0] DDR_dq,
    inout [ 3:0] DDR_dqs_n,
    inout [ 3:0] DDR_dqs_p,
    inout        DDR_odt,
    inout        DDR_ras_n,
    inout        DDR_reset_n,
    inout        DDR_we_n,

    inout        FIXED_IO_ddr_vrn,
    inout        FIXED_IO_ddr_vrp,
    inout [53:0] FIXED_IO_mio,
    inout        FIXED_IO_ps_clk,
    inout        FIXED_IO_ps_porb,
    inout        FIXED_IO_ps_srstb
);

    // 这几个信号是送入system这个自己设计的模块中的
    reg  [31:0] S_AXIS_tdata;  // 总线上发送的数据
    reg         S_AXIS_tlast;
    reg         S_AXIS_tvalid;
    wire        FCLK_CLK0;
    wire        s_axis_aclk;
    wire        s_axis_aresetn;
    wire [ 3:0] S_AXIS_tkeep;
    wire        S_AXIS_tready;
    wire [ 0:0] gpio_rtl_tri_o;     // 该信号通过PS输出
    wire [ 0:0] peripheral_aresetn;  // 外设低电平复位信号
    reg  [ 1:0] state;


    // AXI Stream协议
    assign S_AXIS_tkeep = 4'b1111;  // 发送的32bit数据都有效
    assign s_axis_aclk = FCLK_CLK0;
    assign s_axis_aresetn = peripheral_aresetn;

    // 循环状态机, 因此循环发送数据
    always @(posedge FCLK_CLK0) begin
        if (!peripheral_aresetn) begin
            S_AXIS_tvalid <= 1'b0;
            S_AXIS_tdata <= 32'd0;
            S_AXIS_tlast <= 1'b0;
            state <= 0;
        end else begin
            case (state)
                0: begin
                    if (gpio_rtl_tri_o && S_AXIS_tready) begin
                        S_AXIS_tvalid <= 1'b1;
                        state <= 1;
                    end else begin
                        S_AXIS_tvalid <= 1'b0;
                        state <= 0;
                    end
                end
                1: begin  // 发送过程, 一次发送512个data
                    if (S_AXIS_tready) begin  // 发送的第一个数据是0,不是1
                        S_AXIS_tdata <= S_AXIS_tdata + 1'b1;
                        if (S_AXIS_tdata == 16'd510) begin
                            // 发送的最后一个数据是511, 这里是为了让last与511同步
                            S_AXIS_tlast <= 1'b1;
                            state <= 2;
                        end else begin
                            S_AXIS_tlast <= 1'b0;
                            state <= 1;
                        end
                    end else begin
                        S_AXIS_tdata <= S_AXIS_tdata;
                        state <= 1;
                    end
                end
                2: begin  // 发送最后一个数据时已经state=2了
                    if (!S_AXIS_tready) begin  // 如果此时slave没准备接收
                        S_AXIS_tvalid <= 1'b1;
                        S_AXIS_tlast <= 1'b1;
                        S_AXIS_tdata <= S_AXIS_tdata;
                        state <= 2;
                    end else begin  // 已经准备好接收了
                        S_AXIS_tvalid <= 1'b0;
                        S_AXIS_tlast <= 1'b0;
                        S_AXIS_tdata <= 32'd0;
                        state <= 0;
                    end
                end
                default: state <= 0;
            endcase
        end
    end

    system system_i (
        .DDR_addr   (DDR_addr),
        .DDR_ba     (DDR_ba),
        .DDR_cas_n  (DDR_cas_n),
        .DDR_ck_n   (DDR_ck_n),
        .DDR_ck_p   (DDR_ck_p),
        .DDR_cke    (DDR_cke),
        .DDR_cs_n   (DDR_cs_n),
        .DDR_dm     (DDR_dm),
        .DDR_dq     (DDR_dq),
        .DDR_dqs_n  (DDR_dqs_n),
        .DDR_dqs_p  (DDR_dqs_p),
        .DDR_odt    (DDR_odt),
        .DDR_ras_n  (DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n   (DDR_we_n),
        .FCLK_CLK0  (FCLK_CLK0),    // output

        .FIXED_IO_ddr_vrn (FIXED_IO_ddr_vrn),  // 不需要管FIXED_IO
        .FIXED_IO_ddr_vrp (FIXED_IO_ddr_vrp),
        .FIXED_IO_mio     (FIXED_IO_mio),
        .FIXED_IO_ps_clk  (FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb (FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),

        .S_AXIS_tdata      (S_AXIS_tdata),        // input 需要自己定义
        .S_AXIS_tkeep      (S_AXIS_tkeep),        // input
        .S_AXIS_tlast      (S_AXIS_tlast),        // input
        .S_AXIS_tready     (S_AXIS_tready),       // output
        .S_AXIS_tvalid     (S_AXIS_tvalid),       // input
        .gpio_rtl_tri_o    (gpio_rtl_tri_o),      // ouput 直接在v文件中使用
        .peripheral_aresetn(peripheral_aresetn),  // output
        .s_axis_aclk       (s_axis_aclk),         // input
        .s_axis_aresetn    (s_axis_aresetn)       // input
    );

endmodule
