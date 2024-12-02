// 串口通信模块，uart协议规定发送的数据位只能有6 7 8  已知bps, 传输每bit时间为1/bps
// 串口发送 发送 发送  开发板向电脑发送数据
// 传输一个bit的需要的clk周期数 1/bps * 100MHz / 20ns
module uart_byte (
    input            clock,
    input            reset_n,
    input            send_go,   // 单脉冲信号，控制电平信号send_en 
    input      [3:0] band_set,  // 波特率设置,8种选择
    input      [7:0] data,      // 并行输入
    output reg       uart_tx,   // 串口输出
    output reg       tx_done    // 发送完成
);
    reg [31:0] bps_DR;  // 传输一个bit需要的clk周期数 ;
    reg [31:0] count;  //  每发送一个bit为count一个计数周期
    reg [3:0] bps_count;  //  传输前有一位strat位, 传输后有一位stop位, 一共传输10个bit
    wire bps_clk;
    assign bps_clk = (count == 1);  // 传输一个bit的时钟,脉冲信号
    /* 时序控制信号-----------------
count uart_tx bps_count tx_done send_en
组合逻辑信号-----------------
data bps_clk   */
    // 根据band_set译码bps_DR: 发送一个bit需要的时钟数目  时钟周期20ns
    always @(*) begin
        case (band_set)
            0: bps_DR = 100_0000_000 / 9600 / 20;  // bps=9600
            1: bps_DR = 100_0000_000 / 19200 / 20;  // bps=19200
            2: bps_DR = 100_0000_000 / 38400 / 20;  // bps=38400
            3: bps_DR = 100_0000_000 / 57600 / 20;  //  bps=57600
            default: bps_DR = 100_0000_000 / 115200 / 20;  // 此时bps_DR=434
        endcase
    end

    // 操作send_en
    // 经过send_go和send_en使能，在每个10ms刚开始会有一点延迟才开始发送数据
    reg send_en;
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) send_en <= 0;
        else if (send_go)  // 从这里开始是clock上升沿控制
            send_en <= 1;  // 滞后,但影响不大
        else if (tx_done) send_en <= 0;
    end

    // 存上send_go时刻的data
    reg [7:0] reg_data;
    always @(posedge clock) begin
        if (send_go) reg_data <= data;
        else reg_data <= reg_data;
    end

    // 操作最小计数周期 count
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) count <= 0;
        else if (send_en) begin
            if (count == bps_DR - 1) count <= 0;
            else count <= count + 1;
        end else count <= 0;
    end

    // 操作bps_count,需要计数
    // 设置count == 1为判断条件，send_en使能后，bps_count过一个clock周期就变为1,uart_tx变为0，一个clock周期误差可以接受
    // count == 0 好像也可以 
    /* 原本bps_count 11是稳态，但tx_done使send_en变为0，bps_count变为0
    */
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) bps_count <= 0;
        else if (send_en) begin
            // if语句后面如果接if-else，必须把if语句用begin-end包起来
            if (count == 1) begin
                if (bps_count == 11)  // 10也是一个完整的状态,11只有3个clock周期
                    bps_count <= 0;
                else  // send_en使能一个clock周期后，bps_count就变为1
                    bps_count <= bps_count + 1;
            end
        end else bps_count <= 0;

    end

    // 发送数据, 共10bit
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            // 空闲情况下，uart_tx为1
            uart_tx = 1'b1;  //  看波形有用，send_en使能后，应该立刻变为0
        end else begin  // uart_tx受clock上升沿控制
            case (bps_count)
                1: uart_tx = 1'b0;  // start位
                2: uart_tx = data[0];  // data[0]
                3: uart_tx = data[1];  // data[1]
                4: uart_tx = data[2];  // data[2]
                5: uart_tx = data[3];  // data[3]
                6: uart_tx = data[4];  // data[4]
                7: uart_tx = data[5];
                8: uart_tx = data[6];
                9: uart_tx = data[7];
                10: uart_tx = 1'b1;  // stop位 
                11: uart_tx = 1'b1;  // 发送完成
                default: uart_tx = 1'b1;
            endcase
        end
    end

    // tx_done传输完成信号单独处理
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) tx_done <= 1'b0;
        else if (bps_clk == 1 && bps_count == 10) tx_done <= 1'b1;  // 此时stop位已经发送完了
        else tx_done <= 1'b0;
    end

endmodule
