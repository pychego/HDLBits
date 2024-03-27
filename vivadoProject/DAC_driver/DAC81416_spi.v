// convert parallel dac_cmd to spi serial data
module DAC81416_spi (
                            input             clk,
                            input             rst_n,
                            input      [23:0] dac_cmd,
                            input             dac_cmd_valid,
    (*mark_DEBUG = "TRUE"*) output reg        DAC_CSn,
    (*mark_DEBUG = "TRUE"*) output reg        DAC_SCLK,
    (*mark_DEBUG = "TRUE"*) output reg        DAC_SDI
);

    // cnt_div is two divided-frequency
    reg [3:0] cnt_div;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt_div <= 4'd0;
        else if (cnt_div == 4'd1) cnt_div <= 4'd0;
        else cnt_div <= cnt_div + 1'b1;
    end

    // DAC_SCLK is four divided-frequency of clk, 25MHz, T = 40ns
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) DAC_SCLK <= 1'b0;
        else if (cnt_div == 4'd1) DAC_SCLK <= ~DAC_SCLK;
        else DAC_SCLK <= DAC_SCLK;
    end

    // dac_cmd_valid是和控制信号一起出现的,因此dac_cmd_valid每次持续时间达到0.1ms
    reg [13:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt <= 14'd0;
        else if (dac_cmd_valid) cnt <= cnt + 1'b1;
        else cnt <= 14'd0;
    end

    (*mark_DEBUG = "TRUE"*) wire [13:0] cnt_SCLK;
    // assign cnt_SCLK = cnt >> 1;
    // 因为DAC_SCLK是clk的四分频,所以cnt_SCLK统计的是dac_cmd_valid有效之后DAC_SCLK的周期数
    assign cnt_SCLK = cnt >> 2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) DAC_CSn <= 1'b1;
        // cnt[1:0] is low positions
        else if (cnt[1:0] == 2'b11) begin
            if (dac_cmd_valid) begin
                if (cnt_SCLK <= 5)  
                    //the DAC_CSn high time has to 240ns+, meeting with tCSHIGH
                    DAC_CSn <= 1'b1;
                else if (cnt_SCLK <= 29) DAC_CSn <= 1'b0;   //  ???
                // CSn low keeps 960ns,SCLK cycle is 40ns, so 24 cycles
                else DAC_CSn <= 1'b1;
            end else DAC_CSn <= 1'b1;
        end
    end

    (*mark_DEBUG = "TRUE"*) reg [23:0] dac_cmd_shift;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) dac_cmd_shift <= 24'd0;
        else if (cnt[1:0] == 2'b11) begin
            if (dac_cmd_valid) begin
                if (cnt_SCLK <= 5) dac_cmd_shift <= dac_cmd;
                else if (cnt_SCLK <= 29) dac_cmd_shift <= dac_cmd_shift << 1;
                else dac_cmd_shift <= dac_cmd_shift;
            end else dac_cmd_shift <= 24'd0;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) DAC_SDI <= 1'b0;
        else if (cnt[1:0] == 2'b11) begin
            if (dac_cmd_valid) begin
                if (cnt_SCLK <= 5) DAC_SDI <= 1'b0;
                // The shift operation was performed in the previous always statement
                else if (cnt_SCLK <= 29) DAC_SDI <= dac_cmd_shift[23];
                else DAC_SDI <= 1'b0;
            end else DAC_SDI <= 1'b0;
        end
    end

endmodule
/*
整个DAC流程(这里不考虑初始化了,很简单):

    1. 设置分频 count_10kHz 0-9,十个状态,每个状态持续0.1ms,总共1ms,在8时传送 有效的控制命令dac_cmd
        并设置dac_cmd_valid=1,持续0.1ms
    2. 在dac_cmd_valid=1的0.1ms中,完成了spi的整个传输
    3. DAC_SCLK是clk的四分频,在dac_cmd_valid有效之后就开始统计SLK的个数cnt_SCLK,只需要24个SCLK周期
        即可完成24位的数据传输
*****************************************************************
    1ms控制周期内有关DAC的时序操作
    count_10kHz=0  : 开始了一个控制周期
    count_10kHz=1  : BRAM控制器从BRAM中取出参考波形
    count_10kHz=2-6: 是计算PID控制输出的过程
    count_10kHz=7  : 计算出了PID控制的输出电压control_output[15:0]
    count_10kHz=8  : control_output[15:0]包装成dac_cmd[23:0],dac_cmd_valid=1持续0.1ms
                    在此期间完成了spi协议,将并行数据转换成串行数据送入了DAC81416,其输出控制电压



*/