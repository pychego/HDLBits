// 思想，将10个bit的发送时间分成了160段 每个bit划分16段 在每段的中点采样
// 舍弃前5段和后4段
module uart_byte_rx (
    input            clock,
    input            reset_n,
    input      [2:0] band_set,  // 一定要定义信号的位宽，不然就默认为1了
    input            uart_rx,
    output reg [7:0] data,
    output reg       rx_done
);

    // 时序信号 uart_rx, rx_done脉冲 rx_en电平
    // 组合逻辑 nedge_uart_rx

    // 记录采样值
    // 相当于二维数组 reg width name number/depth
    // 二维数组赋值要一个一个来
    reg [2:0] r_data    [7:0];
    reg [2:0] sta_bit;
    reg [2:0] sto_bit;

    // 避免亚稳态，使用三个触发器
    reg [2:0] uart_rx_r;
    always @(posedge clock) begin
        uart_rx_r <= {uart_rx_r[1:0], uart_rx}; 
    end

    // 定义uart_rx的上升沿和下降沿
    wire pedge_uart_rx, nedge_uart_rx;
    assign pedge_uart_rx = (uart_rx_r[2:1] == 2'b01);
    assign nedge_uart_rx = (uart_rx_r[2:1] == 2'b10);  // 检测到了uart_rx的下降沿 脉冲信号

    // 定义发送使能信号,规定了采样开始时间
    // !! 很重要的信号
    reg rx_en;
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) rx_en <=  1'b0;
        else if (nedge_uart_rx) rx_en <=  1'b1;  // 在数据正传输过程中这句话可有可无
        // 遇到了传输完成或者错误的起始位
        else if (rx_done || (sta_bit >= 4)) rx_en <=  1'b0;
    end

    reg [31:0] bps_DR;  // 每一位采样16次，舍弃前5次和后4次
    always @(*) begin
        case (band_set)  // 擦色语句必须卸载always块中，不加begin end
            0: bps_DR = 1000_000_000 / 9600 / 16 / 20 - 1;  // 波特率9600
            1: bps_DR = 1000_000_000 / 19200 / 16 / 20 - 1;
            2: bps_DR = 1000_000_000 / 38400 / 16 / 20 - 1;
            3: bps_DR = 1000_000_000 / 57600 / 16 / 20 - 1;
            4: bps_DR = 1000_000_000 / 115200 / 16 / 20 - 1;
            default: bps_DR = 1000_000_000 / 9600 / 16 / 20 - 1;
        endcase
    end

    reg  [31:0] count;
    // 1个bit采样16次，一次要bps_DR个clk周期,每次采样在bps_DR/2的位置
    wire        bps_clk_16x;
    // bps_clk_16x为1时就要采样了
    assign bps_clk_16x = (count == bps_DR / 2);  // 16次取值，每次都在正中间采样

    // 操作最小计数单元，一个count周期采样一次
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            count <=  0;  // 只有数据来了之后计数才有意义
        end else if (rx_en) begin
            if (count == bps_DR) begin
                count <=  0;
            end else count <=  count + 1;
        end else count <=  1'b0;
    end

    // 记录采样的次数，每bit采样16次，共10bit，采样160次
    // bps_cnt变化一次需要540ns,16次需要8640ns；而传输数据一个bit需要8680ns，由此会每次产生40ns的误差
    // 该误差会在传输每byte中累计,但采样舍弃了头尾，因此对最终结果没影响
    reg [31:0] bps_cnt;
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            bps_cnt <=  0;
        end else if (rx_en) begin
            if (bps_clk_16x) begin
                if (bps_cnt == 159) begin  // 此时159这个状态已经要结束了
                    bps_cnt <=  0;
                end else begin
                    bps_cnt <=  bps_cnt + 1;
                end
            end
        end else bps_cnt <=  1'b0;
    end


    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            sta_bit   <=  0;
            sto_bit   <=  0;
            r_data[0] <=  0;
            r_data[1] <=  0;
            r_data[2] <=  0;
            r_data[3] <=  0;
            r_data[4] <=  0;
            r_data[5] <=  0;
            r_data[6] <=  0;
            r_data[7] <=  0;
        end else if (bps_clk_16x) begin  // bps_clk_16x为采样条件
            case (bps_cnt)  // 每个uart采样16次，舍弃前5次和后4次
                // 注意要有清零的步骤，不然第二个byte的时候会出错
                0: begin
                    sta_bit   <=  0;
                    sto_bit   <=  0;
                    r_data[0] <=  0;
                    r_data[1] <=  0;
                    r_data[2] <=  0;
                    r_data[3] <=  0;
                    r_data[4] <=  0;
                    r_data[5] <=  0;
                    r_data[6] <=  0;
                    r_data[7] <=  0;
                end
                5, 6, 7, 8, 9, 10, 11: sta_bit <=  sta_bit + uart_rx;
                21, 22, 23, 24, 25, 26, 27: r_data[0] <=  r_data[0] + uart_rx;
                37, 38, 39, 40, 41, 42, 43: r_data[1] <=  r_data[1] + uart_rx;
                53, 54, 55, 56, 57, 58, 59: r_data[2] <=  r_data[2] + uart_rx;
                69, 70, 71, 72, 73, 74, 75: r_data[3] <=  r_data[3] + uart_rx;
                85, 86, 87, 88, 89, 90, 91: r_data[4] <=  r_data[4] + uart_rx;
                101, 102, 103, 104, 105, 106, 107: r_data[5] <=  r_data[5] + uart_rx;
                117, 118, 119, 120, 121, 122, 123: r_data[6] <=  r_data[6] + uart_rx;
                133, 134, 135, 136, 137, 138, 139: r_data[7] <=  r_data[7] + uart_rx;
                149, 150, 151, 152, 153, 154, 155: sto_bit <=  sto_bit + uart_rx;
                default: ;  // bps_cnt为其他值就什么也不干
            endcase
        end
    end

    // 采样完成后对data赋值
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) data <=  0;
        // 这里改为158, 是在rx_done上升沿时可以得到data的值
        else if (bps_clk_16x && bps_cnt == 158) begin  // 该时刻对应最后一次采样的瞬间
            // data[0] <=  r_data[0][2];  // 结果一致
            data[0] <=  (r_data[0] >= 4) ? 1'b1 : 1'b0;
            data[1] <=  (r_data[1] >= 4) ? 1'b1 : 1'b0;
            data[2] <=  (r_data[2] >= 4) ? 1'b1 : 1'b0;
            data[3] <=  (r_data[3] >= 4) ? 1'b1 : 1'b0;
            data[4] <=  (r_data[4] >= 4) ? 1'b1 : 1'b0;
            data[5] <=  (r_data[5] >= 4) ? 1'b1 : 1'b0;
            data[6] <=  (r_data[6] >= 4) ? 1'b1 : 1'b0;
            data[7] <=  (r_data[7] >= 4) ? 1'b1 : 1'b0;
        end
    end

    // 操作rx_done 脉冲信号
    // 原本bps_cnt为159就采样结束了，但为了推迟rx_done出现的时间，所以改为161
    // 实际应用中需要在stop发送完之前产生rx_done
    // 从uart_rx下降沿到rx_done脉冲结束需要的时间不足8680ns
    // 和rx_en一样重要
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) rx_done <=  1'b0;
        else if (bps_clk_16x && bps_cnt == 159) rx_done <=  1'b1;
        else rx_done <=  1'b0;
    end

endmodule
