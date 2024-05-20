
module Board2_Get_SSI (
    input clk,
    input rst_n,
    input SSI_data,

    output reg SSI_clk2SSI,      // output to sensor
    output     SSI_clk2Board1,
    output reg SSI_flag2Board1,
    output     SSI_data2Board1,

    output reg led,  // Indicating Board2 is working
    output test_B33IO
);
    // 根据SSI时序可知，SSI_clk每来一个上升沿传感器就送入一个SSI_data 因此要设计在SSI_clk下降沿读取SSI_data

    // 根据cnt计数设计1MHz信号
    reg [7:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt <= 8'd0;
        else if (cnt == 8'd99) cnt <= 8'd0;
        else cnt <= cnt + 1'b1;
    end

    (*mark_DEBUG = "TRUE"*) wire clk_1MHz_en;
    assign clk_1MHz_en = (cnt == 8'd1);

    // count_1MHz from 0 to 72, 73 states in total
    // count_1MHz在每个状态停留的时间是 1 / 1MHz
    (*mark_DEBUG = "TRUE"*) reg [7:0] count_1MHz;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) count_1MHz <= 8'd0;
        else if (clk_1MHz_en) begin
            count_1MHz <= count_1MHz + 1'b1;
            if (count_1MHz > 8'd71) count_1MHz <= 8'd0;
        end
    end

    // SSI_clk's frequency is 1Mhz / 2 = 500kHz
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) SSI_clk2SSI <= 1'b1;
        else if (clk_1MHz_en) begin
            if (count_1MHz < 20) SSI_clk2SSI <= 1'b1;
            else if (count_1MHz == 20) SSI_clk2SSI <= 1'b0;
            else if (count_1MHz > 20 && count_1MHz <= 71) SSI_clk2SSI <= ~SSI_clk2SSI;
            else SSI_clk2SSI <= SSI_clk2SSI;
        end
    end

    // SSI_flag2Board1 is used to indicate the SSI_clk is in the period of 22~71
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) SSI_flag2Board1 <= 1'b0;
        else if (clk_1MHz_en) begin
            if (count_1MHz <= 20) SSI_flag2Board1 <= 1'b0;
            else if (count_1MHz > 20 && count_1MHz < 71) SSI_flag2Board1 <= 1'b1;
            else if (count_1MHz == 71) SSI_flag2Board1 <= 1'b0;
            else SSI_flag2Board1 <= 1'b0;
        end
    end

    assign SSI_clk2Board1  = SSI_clk2SSI;
    assign SSI_data2Board1 = SSI_data;



    // 设置 led 每秒闪烁一次
    reg [31:0] count_for_led;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) count_for_led <= 32'd0;
        else begin
            if (count_for_led == 32'd199_999_999) count_for_led <= 32'd0;
            else count_for_led <= count_for_led + 1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) led <= 1'b0;
        else begin
            if (count_for_led <= 32'd99_999_999) led <= 1;
            else led <= 0;
        end
    end

    // test_B33IO
    assign test_B33IO = led;


endmodule


