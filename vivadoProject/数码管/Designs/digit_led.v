/*
    digit_led input [31:0] disp_data 32位显示数据
              output reg [ 7:0] sel 8个数码管的片选信号
              output reg [ 7:0] seg 段选信号，接到数码管的a~g和dp seg[0]对应a

    数码管显示原理 循环扫描 8个数码管共阴（8个管子的a脚接在一起，b脚接在一起），每个数码管使能端有sel控制 

*/

module digit_led (
    input             clk,
    input             reset_n,
    input      [31:0] disp_data,
    output reg [ 7:0] sel,
    output reg [ 7:0] seg
);

/*
    时序逻辑 num sel disp_temp
    组合逻辑 seg
*/

    // 每次每个数码管显示1ms，需要50000个clk
    reg [31:0] count;
    parameter MCNT = 50_000;
    // 分频器
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            count <= 0;
        end else if (MCNT - 1 <= count) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end

    // 设计八进制计数器 
    reg [2:0] num;
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            num <= 0;
        end else if (MCNT - 1 <= count) begin
            num <= num + 1;  // 自动归零
        end
    end

    // 优先使用时序逻辑设计 让电路性能更优异
    // 3-8译码器 译出片选信号sel
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            sel <= 8'b0000_0000;
        end else begin
            case (num)
                0: sel <= 8'b0000_0001;
                1: sel <= 8'b0000_0010;
                2: sel <= 8'b0000_0100;
                3: sel <= 8'b0000_1000;
                4: sel <= 8'b0001_0000;
                5: sel <= 8'b0010_0000;
                6: sel <= 8'b0100_0000;
                7: sel <= 8'b1000_0000;
                default: ;
            endcase
        end
    end

    // 设计共阴管教abcdefg dp的驱动
    // MUX 当num=0，选中最低位数码管显示
    reg [3:0] disp_per_num;  // 规定显示0-f

    // 将sel和disp_per_num都设置为同步信号，受num控制 而最终显示译码4-16线 为组合逻辑，可以配合好
    always @(posedge clk) begin
        case (num)
            0: disp_per_num <= disp_data[3:0];
            1: disp_per_num <= disp_data[7:4];
            2: disp_per_num <= disp_data[11:8];
            3: disp_per_num <= disp_data[15:12];
            4: disp_per_num <= disp_data[19:16];
            5: disp_per_num <= disp_data[23:20];
            6: disp_per_num <= disp_data[27:24];
            7: disp_per_num <= disp_data[31:28];
            default: ;
        endcase
    end

    // LUT   Look Up Table 查找表
    // 4-16译码器 译出段选信号seg 接到a b c d e f g dp
    always @(*) begin
        case (disp_per_num)
            0: seg <= 8'hc0;
            1: seg <= 8'hf9;
            2: seg <= 8'ha4;
            3: seg <= 8'hb0;
            4: seg <= 8'h99;
            5: seg <= 8'h92;
            6: seg <= 8'h82;
            7: seg <= 8'hf8;
            8: seg <= 8'h80;
            9: seg <= 8'h90;
            4'ha: seg <= 8'h88;
            4'hb: seg <= 8'h83;
            4'hc: seg <= 8'hc6;
            4'hd: seg <= 8'ha1;
            4'he: seg <= 8'h86;
            4'hf: seg <= 8'h8e;
            default: ;
        endcase
    end

endmodule
