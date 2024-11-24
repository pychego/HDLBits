// convert parallel dac_cmd to spi serial data
/*  2025.11.24 
    将reg [23:0] dac_cmd 根据dac_cmd_vaild转化为符合SPI协议的串行数据
接口:
    DAC_CSn SPI数据片选信号, 低电平有效, 该信号要严格控制持续时间,确保正好传输dac_cmd[23:0]
    DAC_SCLK SPI协议传输过程的时钟信号
    DAC_SDI SPI协议传输的串行数据
*/



module DAC81416_spi (
    input             clk,
    input             rst_n,
    input      [23:0] dac_cmd,
    input             dac_cmd_valid,

    output reg        DAC_CSn,
    output reg        DAC_SCLK,     // 25MHz
    output reg        DAC_SDI
);

    // cnt_div is two divided-frequency 二分频 50Mhz
    reg [3:0] cnt_div;
    always @(posedge clk, negedge rst_n) begin
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

    // dac_cmd_valid 是和控制信号一起出现的,因此dac_cmd_valid每次持续时间达到0.1ms
    // cnt 统计dac_cmd_valid之后出现的clk周期数
    reg [13:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt <= 14'd0;
        else if (dac_cmd_valid) cnt <= cnt + 1'b1;
        else cnt <= 14'd0;
    end

    wire [13:0] cnt_SCLK;
    // assign cnt_SCLK = cnt >> 1;
    // 因为DAC_SCLK是clk的四分频,所以cnt_SCLK统计的是dac_cmd_valid有效之后DAC_SCLK的周期数
    assign cnt_SCLK = cnt >> 2;

    /*  后面判断条件cnt[1:0] == 2'b11生成DAC_CSn和DAC_SDI
        都是为了避开SCLK的上升沿和下降沿
    */
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) DAC_CSn <= 1'b1;
        // cnt[1:0] is low positions
        // cnt[1:0] == 2'b11 再来一个clk就计数一次 DAC_SCLK
        else if (cnt[1:0] == 2'b11) begin
            if (dac_cmd_valid) begin
                if (cnt_SCLK <= 5)  
                    //the DAC_CSn high time has to 240ns+, meeting with tCSHIGH
                    DAC_CSn <= 1'b1;
                else if (cnt_SCLK <= 29) DAC_CSn <= 1'b0; // 7~30完整24个状态都是0
                // CSn low keeps 960ns,SCLK cycle is 40ns, so 24 cycles
                // 1000ns=1us=0.001ms
                else DAC_CSn <= 1'b1;
            end else DAC_CSn <= 1'b1;
        end
    end

    reg [23:0] dac_cmd_shift;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) dac_cmd_shift <= 24'd0;
        else if (cnt[1:0] == 2'b11) begin
            if (dac_cmd_valid) begin
                if (cnt_SCLK <= 5) dac_cmd_shift <= dac_cmd;
                else if (cnt_SCLK <= 29) dac_cmd_shift <= (dac_cmd_shift << 1);
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
                // 先传输高位,后传输低位
                else if (cnt_SCLK <= 29) DAC_SDI <= dac_cmd_shift[23];
                else DAC_SDI <= 1'b0;
            end else DAC_SDI <= 1'b0;
        end
    end

endmodule

/*通过时序图验证CSn, SCLK 和 SDI 的时序
    CSn下降沿之后20ns(半个SCLK周期)之后 是SCLK的下降沿, 此时是cnt_SCLK=7的正中间, 开始取bit23
    直到cnt_SCLK=30的正中间,是SCLK取数的最后一个下降沿,取bit0, 在经过20ns之后,CSn上升沿,传输结束
*/


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