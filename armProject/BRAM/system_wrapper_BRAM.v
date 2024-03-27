/*
  PL 部分逻辑设计主要包括以下几个过程：
  检测 AXI GPIO 输出的 GPIO0 的上升沿；
  若检测到 GPIO0 的上升沿，则从 BRAM 的某 1 个地址中读出 1 个 PS 写入 32 位数据，然后加 2，存入原地址
  中；
  1 个 32 数据存储完毕后，将 AXI GPIO 的输入信号 GPIO1 进行翻转，告知 PS 一次数据读写完成。
  不断循环上述过程，依次遍历 BRAM 中 0~4092 的地址范围。
*/
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/22 08:24:50
// Design Name: 
// Module Name: system_wrapper_BRAM
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

module system_wrapper_BRAM (
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
    //  GPIO是一个内部接口

    wire [31:0] BRAM_PORTB_addr;
    wire BRAM_PORTB_clk;
    wire [31:0] BRAM_PORTB_din;
    wire [31:0] BRAM_PORTB_dout;
    wire BRAM_PORTB_en;
    wire BRAM_PORTB_rst;
    wire [3:0] BRAM_PORTB_we;   // 写使能端口, 高电平写入
    wire [0:0] GPIO_tri_i_0;
    wire [1:1] GPIO_tri_i_1;
    wire [0:0] GPIO_tri_o_0;
    wire [1:1] GPIO_tri_o_1;
    wire [0:0] aresetn;

    reg [2:0]gpio_tri_o_0_reg;  // PS送给PL的通知信号
    reg ps_bram_wr_done;
    reg pl_bram_wr_done;
    reg bram_en;
    reg [3:0]  bram_we;  // write enable. 4bit,每bit控制写入8bit数据,总共控制写入32bit数据
    reg [31:0] bram_addr;
    reg [31:0] bram_rd_data;
    reg [31:0] bram_wr_data;
    reg [2:0] state;

    // 存储空间大小 4KB = 32bit * 1024
    localparam BRAM_ADDRESS_HIGH = 32'd4096 - 32'd4;

    // FCLK_CLK0 在bd文件的内部, 可以直接使用
    // 寄存器用来检测 GPIO0 的上升沿
    // always @(posedge FCLK_CLK0) begin
    //     if (!aresetn) gpio_tri_o_0_reg <= 1'b0;
    //     else gpio_tri_o_0_reg <= GPIO_tri_o_0;
    // end

    // // ps写完一个32bit数据后发出一个GPIO0上升沿给PL
    // always @(posedge FCLK_CLK0) begin
    //     if (!aresetn) ps_bram_wr_done <= 1'b0;
    //     else if ({gpio_tri_o_0_reg, GPIO_tri_o_0} == 2'b01)  //gpio0 rising edge
    //         ps_bram_wr_done <= 1'b1;
    //     else ps_bram_wr_done <= 1'b0;
    // end

    // 使用三级寄存器检测GPIO0上升沿  GPIO0由sdk产生
    always @(posedge FCLK_CLK0) begin
        if (!aresetn) gpio_tri_o_0_reg <= 1'b0;
        else gpio_tri_o_0_reg <= {gpio_tri_o_0_reg[1:0], GPIO_tri_o_0};
    end
    // 上升沿和下降沿判断 脉冲信号, 三级寄存器等两拍确定边沿
    wire pedge;
    assign pedge = gpio_tri_o_0_reg[2:1] == 2'b01;

    // ps写完一个32bit数据后发出一个GPIO0上升沿给PL
    always @(posedge FCLK_CLK0) begin
        if (!aresetn) ps_bram_wr_done <= 1'b0;
        else if (pedge)  //gpio0 rising edge
            ps_bram_wr_done <= 1'b1;
        else ps_bram_wr_done <= 1'b0;
    end

    // 核心代码, 状态机 写写画画可以理解
    // 写状态机一定要知道接口的时序, 根据时序写状态机
    always @(posedge FCLK_CLK0) begin
        if (!aresetn) begin
            bram_we <= 4'd0;
            bram_en <= 1'b0;
            bram_addr <= 32'd0;
            bram_rd_data <= 32'd0;
            bram_wr_data <= 32'd0;
            pl_bram_wr_done <= 1'b0;
            state <= 3'd0;
        end else begin
            case (state)
                0: begin
                    if (ps_bram_wr_done) begin
                        bram_en <= 1'b1;
                        bram_we <= 4'd0;
                        state   <= 1;
                    end else begin
                        state <= 0;
                        bram_en <= 1'b0;
                        bram_we <= 4'd0;
                        bram_addr <= bram_addr;
                    end
                end
                // 在工程代码力state=1的时设置为了bram_en <= 1'b1; 没任何影响
                1: begin        // 感觉1这个状态没必要存在
                    bram_en <= 1'b0;    // ??? 为什么中间要关闭一次使能,感觉没必要关闭
                    state   <= 2;
                end
                2: begin            // BRAM_PORTB_dout应该是根据bram_addr得到的
                    bram_rd_data <= BRAM_PORTB_dout;
                    state <= 3;
                end
                3: begin
                    bram_en <= 1'b1;
                    bram_we <= 4'hf;
                    // PL把从BRAM中读出的数据加2后写回BRAM
                    // 将AXI GPIO的输入信号 GPIO1 进行翻转，告知 PS 一次数据读写完成
                    bram_wr_data <= bram_rd_data + 2;
                    pl_bram_wr_done <= ~pl_bram_wr_done;
                    state <= 4;
                end
                4: begin
                    state   <= 0;
                    bram_en <= 1'b0;
                    if (bram_addr == BRAM_ADDRESS_HIGH) bram_addr <= 32'd0;
                    else bram_addr <= bram_addr + 32'd4;
                end
                default: state <= 0;
            endcase
        end
    end


    // 结合bd文件,将BRAM_PORTB连接到PL
    assign BRAM_PORTB_en   = bram_en;  // 写入bram有效信号(总的使能信号)
    assign BRAM_PORTB_we   = bram_we;  // 写入bram使能信号(写使能信号) write enable
    assign BRAM_PORTB_rst  = ~aresetn;
    assign BRAM_PORTB_clk  = FCLK_CLK0;
    assign BRAM_PORTB_addr = bram_addr;
    assign BRAM_PORTB_din  = bram_wr_data;

    assign GPIO_tri_i_1    = pl_bram_wr_done;

    system system_i (
        .BRAM_PORTB_addr  (BRAM_PORTB_addr),
        .BRAM_PORTB_clk   (BRAM_PORTB_clk),
        .BRAM_PORTB_din   (BRAM_PORTB_din),
        .BRAM_PORTB_dout  (BRAM_PORTB_dout),
        .BRAM_PORTB_en    (BRAM_PORTB_en),
        .BRAM_PORTB_rst   (BRAM_PORTB_rst),
        .BRAM_PORTB_we    (BRAM_PORTB_we),
        .DDR_addr         (DDR_addr),
        .DDR_ba           (DDR_ba),
        .DDR_cas_n        (DDR_cas_n),
        .DDR_ck_n         (DDR_ck_n),
        .DDR_ck_p         (DDR_ck_p),
        .DDR_cke          (DDR_cke),
        .DDR_cs_n         (DDR_cs_n),
        .DDR_dm           (DDR_dm),
        .DDR_dq           (DDR_dq),
        .DDR_dqs_n        (DDR_dqs_n),
        .DDR_dqs_p        (DDR_dqs_p),
        .DDR_odt          (DDR_odt),
        .DDR_ras_n        (DDR_ras_n),
        .DDR_reset_n      (DDR_reset_n),
        .DDR_we_n         (DDR_we_n),
        .FCLK_CLK0        (FCLK_CLK0),                     // output
        .FIXED_IO_ddr_vrn (FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp (FIXED_IO_ddr_vrp),
        .FIXED_IO_mio     (FIXED_IO_mio),
        .FIXED_IO_ps_clk  (FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb (FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .GPIO_tri_i       ({GPIO_tri_i_1, GPIO_tri_i_0}),
        .GPIO_tri_o       ({GPIO_tri_o_1, GPIO_tri_o_0}),
        .GPIO_tri_t       (),                              // 没有使用到三态控制
        .aresetn          (aresetn)
    );

endmodule
