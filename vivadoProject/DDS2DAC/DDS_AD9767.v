/*
    顶层模块 基于AD9767高速DAC的DDS信号发生器  这个DAC模块的精度是14位
    1 做一个双通道的信号发生器输出 DDS通道例化两次
    2 能够简单的调整每个通道的频率输出（通过按键来循环切换几个固定的频率输出）
    3 能够简单的调整每个通道的输出相位（通过按键来循环切换几个固定的相位输出）
    4 能够输出的波形形式（正弦波 方波 三角波）

    基本可以完成了
*/
module DDS_AD9767 (
    input         clk,
    input         reset_n,
    input  [ 1:0] mode_sel_a,  // 选择输出的波形
    input  [ 1:0] mode_sel_b,
    input  [ 3:0] key,         // 4个按键控制fword_a, fword_b, pword_a, pword_b变化
    output clk_a,
    output clk_b,
    output wrt_a,
    output wrt_b,
    output [13:0] data_a,
    output [13:0] data_b
);

    assign clk_a = clk;
    assign clk_b = clk;
    assign wrt_a = clk_a;
    assign wrt_b = clk_b;

    reg [31:0] fword_a, fword_b;
    reg [11:0] pword_a, pword_b;  // 长度和地址长度相同


    // 每次调整pword 就让dds从addr=0开始输出 这样同频时相位可以同步
    DDS_module DDS_module_a (
        .clk     (clk),
        .reset_n (filter_value[2] | filter_value[3]),
        .mode_sel(mode_sel_a),
        .fword   (fword_a),
        .pword   (pword_a),
        .data    (data_a)       // output
    );

    DDS_module DDS_module_b (
        .clk     (clk),
        .reset_n (filter_value[2] | filter_value[3]),
        .mode_sel(mode_sel_b),
        .fword   (fword_b),
        .pword   (pword_b),
        .data    (data_b)
    );


    // 四个按键，需要四个按键消抖模块 shake_suppression
    wire [3:0] key_flag;  // 中间连线
    wire [3:0] filter_value;
    shake_suppression shake_suppression_fword_a (
        .clk         (clk),
        .reset_n     (reset_n),
        .key_value   (key[0]),
        .key_flag    (key_flag[0]),     // output
        .filter_value(filter_value[0])
    );

    shake_suppression shake_suppression_fword_b (
        .clk         (clk),
        .reset_n     (reset_n),
        .key_value   (key[1]),
        .key_flag    (key_flag[1]),
        .filter_value(filter_value[1])
    );

    shake_suppression shake_suppression_pword_a (
        .clk         (clk),
        .reset_n     (reset_n),
        .key_value   (key[2]),
        .key_flag    (key_flag[2]),
        .filter_value(filter_value[2])
    );

    shake_suppression shake_suppression_pword_b (
        .clk         (clk),
        .reset_n     (reset_n),
        .key_value   (key[3]),
        .key_flag    (key_flag[3]),
        .filter_value(filter_value[3])
    );

    // 设计8位计数器，每次按键按下，计数器加一 对应按键改变fword或者pword
    reg [2:0] fword_a_sel, fword_b_sel, pword_a_sel, pword_b_sel;
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            fword_a_sel <= 0;
            fword_b_sel <= 0;
            pword_a_sel <= 0;
            pword_b_sel <= 0;
        end else begin
            // 按键按下，计数器加一（也可改写位按键释放，计数器加一）
            if (key_flag[0] && filter_value[0] == 0) begin
                fword_a_sel <= fword_a_sel + 1;
            end
            if (key_flag[1] && filter_value[1] == 0) begin
                fword_b_sel <= fword_b_sel + 1;
            end
            if (key_flag[2] && filter_value[2] == 0) begin
                pword_a_sel <= pword_a_sel + 1;
            end
            if (key_flag[3] && filter_value[3] == 0) begin
                pword_b_sel <= pword_b_sel + 1;
            end
        end
    end

    // 根据四个计数器做LUT
    /*
        fword = F_0 * 2^N / F_clk
        直接使用2**20 综合出的电路和预想不一样 直接使用最终数值
    */
    always @(*) begin
        case (fword_a_sel)
            0: fword_a <= 86;  
            1: fword_a <= 859;
            2: fword_a <= 8500;
            3: fword_a <= 85899;
            4: fword_a <= 858993;
            5: fword_a <= 8589935;
            6: fword_a <= 85899346;
            7: fword_a <= 429496730;
            default: ;
        endcase
    end

    always @(*) begin
        case (fword_b_sel)
            0: fword_b <= 86;  
            1: fword_b <= 859;
            2: fword_b <= 8500;
            3: fword_b <= 85899;
            4: fword_b <= 858993;
            5: fword_b <= 8589935;
            6: fword_b <= 85899346;
            7: fword_b <= 429496730;
            default: ;
        endcase
    end

    always @(*) begin
        case (pword_a_sel)
            0: pword_a <= 0;
            1: pword_a <= 341;  // 30度 30/360 * 4096 = 341
            2: pword_a <= 683;
            3: pword_a <= 1024;
            4: pword_a <= 1707;
            5: pword_a <= 2048;
            6: pword_a <= 3072;
            7: pword_a <= 3641;
            default: ;
        endcase
    end

    always @(*) begin
        case (pword_b_sel)
            0: pword_b <= 0;
            1: pword_b <= 341;  // 30度 30/360 * 4096 = 341
            2: pword_b <= 683;
            3: pword_b <= 1024;
            4: pword_b <= 1707;
            5: pword_b <= 2048;
            6: pword_b <= 3072;
            7: pword_b <= 3641;
            default: ;
        endcase
    end



endmodule
