// 串口接收模块，设计接受1byte的模块

module uart_rx_data (
    input            clock,
    input            reset_n,
    input            band_set,
    input            uart_rx,
    output reg [7:0] data,      // 接收的数据
    output reg       rx_done
);

    reg [31:0] bps_DR;  // 传输一个bit需要的clk周期数 ;
    reg [31:0] count;  // 最小计数值
    reg [3:0] bps_count;  //  传输前有一位strat位, 传输后有一位stop位, 一共传输10个bit
    wire bps_clk;  // 来一bit就输出一个上升沿

    assign bps_clk = (count == 1);

    /* 时序控制信号 receive_go
    组合逻辑信号 bps_clk
*/
    // 根据band_set译码bps_DR
    always @(*) begin
        case (band_set)
            0: bps_DR = 100_0000_000 / 9600 / 20;  // bps=9600
            1: bps_DR = 100_0000_000 / 19200 / 20;  // bps=19200
            2: bps_DR = 100_0000_000 / 38400 / 20;  // bps=38400
            3: bps_DR = 100_0000_000 / 57600 / 20;  //  bps=57600
            default: bps_DR = 100_0000_000 / 115200 / 20;
        endcase
    end

    // 判断是否开始start位(检测下降沿) 操作receive_go 脉冲信号  
    reg d0, d1, receive_go;  // 上电之后只要有下降沿马上开始接受信号
    reg flag;
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            d0 <= 1'b0;
            d1 <= 1'b0;
            flag <= 1'b0;
            receive_go <= 1'b0;
        end else if (d1 > d0 && flag == 0) begin
            receive_go <= 1'b1;
            flag <= 1'b1;
        end else begin
            d0 <= uart_rx;
            d1 <= d0;
            receive_go <= 1'b0;
        end
    end

    // 接收使能信号，电平信号
    reg receive_en;
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) receive_en <= 0;
        else if (receive_go)  // 从这里开始是clock上升沿控制
            receive_en <= 1;  // 滞后,但影响不大
        else if (rx_done) receive_en <= 0;
    end


    // 操作最小计数值count
    always @(negedge clock or negedge reset_n) begin
        if (!reset_n) begin
            count <= 0;
        end else begin
            if (receive_en) begin
                if (count == bps_DR - 1) count <= 0;
                else count <= count + 1;
            end else count <= 0;
        end
    end

    // 根据count赋值bps_count，每个bps_count值持续时间位count从2~1
    // 原本11是稳态，但由于受到receive_en控制，只存在很短时间就消失了
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) bps_count <= 0;
        else if (receive_en) begin
            // if语句后面如果接if-else，必须把if语句用begin-end包起来
            if (count == 1) begin
                if (bps_count == 11)  // 10也是一个完整的状态,11只有3个clock周期
                    bps_count <= 0;
                else  // send_en使能一个clock周期后，bps_count就变为1
                    bps_count <= bps_count + 1;
            end
        end else bps_count <= 0;

    end

    wire sample_data;  // 采样得到的数据
    wire sample_done;
    sample_card sample_card (
        .clock      (clock),
        .reset_n    (reset_n),
        .uart_rx    (uart_rx),
        .bps_DR     (bps_DR),
        .sample_done(sample_done),
        .dvalue     (sample_data)
    );


    // 为简单，只8bit数据进行取样，每个bps_count内取样7次
    // 应该把采样模块封装，进行例化
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            data <= 8'b0;
        end else begin
            case (bps_count)
                2: begin
                    data[0] <= sample_data;
                end
                3: begin
                    data[1] <= sample_data;
                end
                4: begin
                    data[2] <= sample_data;
                end
                5: begin
                    data[3] <= sample_data;
                end
                6: begin
                    data[4] <= sample_data;
                end
                7: begin
                    data[5] <= sample_data;
                end
                8: begin
                    data[6] <= sample_data;
                end
                9: begin
                    data[7] <= sample_data;
                end
                default: data <= data;
            endcase
        end

    end

    // 操作rx_done, 为脉冲信号
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            rx_done <= 1'b0;
        end else if (bps_clk == 1 && bps_count == 10) begin
            rx_done <= 1'b1;
        end else begin
            rx_done <= 1'b0;
        end
    end


endmodule
