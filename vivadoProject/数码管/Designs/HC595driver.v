/*
    驱动74hc595芯片 595（移位寄存器）将串行数据转化为并行数据

    该模块功能将并行data转换位串行dio输出
    HC595driver  input [15:0] data={seg, sel} 16位并行
                 output seg7_sclk  自己造一个12.5MHz的时钟， 控制data串行输出
                 output seg7_rclk  data串行输出结束后发出使能脉冲， 控制595芯片将data并行输出
                 output seg7_dio   data的串行输出信号

    key seg7_sclk和dio的值配合 在sclk下降沿改变dio的值
*/

module HC595driver (
    input             clk,
    input             reset_n,
    input             s_en,       // 脉冲使能信号，高电平时用寄存器保存data的值
    input      [15:0] data,       
    output reg        seg7_sclk,  
    output reg        seg7_rclk,
    output reg        seg7_dio
);

    reg [15:0] r_data;
    always @(posedge clk) begin
        if (s_en) begin
            r_data <= data;
        end
    end
    // 这里不寄存data也可以，若在传输中间data改变，这一轮串行传输的值有误，但是下一轮就会改正。
    // 其中一轮传输错误肉眼看不到

    // 定义sck_plus作为脉冲信号，频率是seg7_sclk的二倍，为25MHz
    reg [31:0] count;
    parameter CNT_MAX = 2;

    // 计数器
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            count <= 0;
        end else if (count == CNT_MAX - 1) begin  
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end

    wire        sclk_plus = (count == 1);   // 25MHz

    // 记录sclk_plus的上升沿个数，需要32个上升沿
    reg  [31:0] sclk_edge_cnt;  
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            sclk_edge_cnt <= 0;
        end else if (sclk_plus) begin
            if (32 <= sclk_edge_cnt) begin
                sclk_edge_cnt <= 0;
            end else begin
                sclk_edge_cnt <= sclk_edge_cnt + 1;
            end
        end
    end

    // 根据sclk_edge_cnt的值，将r_data的值串行输出到seg7_dio
    // 注意需要在seg7_sclk的下降沿改变dio的值
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            seg7_dio  <= 0;
            seg7_rclk <= 0;
            seg7_sclk <= 0;
        end
        begin
            case (sclk_edge_cnt)
                0: begin
                    seg7_rclk <= 0;
                    seg7_sclk <= 0;
                    seg7_dio  <= r_data[15];
                end
                1:  seg7_sclk <= 1;  // sclk上升沿r_data是稳定的
                2: begin
                    seg7_sclk <= 0;
                    seg7_dio  <= r_data[14];
                end
                3:  seg7_sclk <= 1;  // sclk上升沿r_data是稳定的
                4: begin
                    seg7_sclk <= 0;
                    seg7_dio  <= r_data[13];
                end
                5:  seg7_sclk <= 1;  // sclk上升沿r_data是稳定的
                6: begin
                    seg7_sclk <= 0;
                    seg7_dio  <= r_data[12];
                end
                7:  seg7_sclk <= 1;  // sclk上升沿r_data是稳定的
                8: begin
                    seg7_sclk <= 0;
                    seg7_dio  <= r_data[11];
                end
                9:  seg7_sclk <= 1;  // sclk上升沿r_data是稳定的
                10: begin
                    seg7_sclk <= 0;
                    seg7_dio  <= r_data[10];
                end
                11: seg7_sclk <= 1;  // sclk上升沿r_data是稳定的
                12: begin
                    seg7_sclk <= 0;
                    seg7_dio  <= r_data[9];
                end
                13: seg7_sclk <= 1;  // sclk上升沿r_data是稳定的
                14: begin
                    seg7_sclk <= 0;
                    seg7_dio  <= r_data[8];
                end
                15: seg7_sclk <= 1;  // sclk上升沿r_data是稳定的
                16: begin
                    seg7_sclk <= 0;
                    seg7_dio  <= r_data[7];
                end
                17: seg7_sclk <= 1;  // sclk上升沿r_data是稳定的
                18: begin
                    seg7_sclk <= 0;
                    seg7_dio  <= r_data[6];
                end
                19: seg7_sclk <= 1;  // sclk上升沿r_data是稳定的
                20: begin
                    seg7_sclk <= 0;
                    seg7_dio  <= r_data[5];
                end
                21: seg7_sclk <= 1;  // sclk上升沿r_data是稳定的
                22: begin
                    seg7_sclk <= 0;
                    seg7_dio  <= r_data[4];
                end
                23: seg7_sclk <= 1;  // sclk上升沿r_data是稳定的
                24: begin
                    seg7_sclk <= 0;
                    seg7_dio  <= r_data[3];
                end
                25: seg7_sclk <= 1;  // sclk上升沿r_data是稳定的
                26: begin
                    seg7_sclk <= 0;
                    seg7_dio  <= r_data[2];
                end
                27: seg7_sclk <= 1;  // sclk上升沿r_data是稳定的
                28: begin
                    seg7_sclk <= 0;
                    seg7_dio  <= r_data[1];
                end
                29: seg7_sclk <= 1;  // sclk上升沿r_data是稳定的
                30: begin
                    seg7_sclk <= 0;
                    seg7_dio  <= r_data[0];
                end
                31: seg7_sclk <= 1;  // sclk上升沿r_data是稳定的
                32: begin
                    seg7_rclk <= 1;
                end
                default: begin
                    seg7_dio  <= 0;
                    seg7_rclk <= 0;
                    seg7_sclk <= 0;
                end
            endcase
        end
    end

endmodule
