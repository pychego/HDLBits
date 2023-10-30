// 串口通信模块
// 已知bps, 传输每bit时间为1/bps
// 传输一个bit的需要的clk周期数 1/bps * 100MHz / 20ns
module uart_tx (
    input clock,
    input reset_n,
    input send_en,   // 开始发送 
    input [3:0]band_set, // 波特率设置,8种选择
    input [7:0] data,  // 并行输入
    output reg uart_tx,  // 串口输出
    output reg tx_done   // 发送完成
);
    reg [31:0] bps_DR;  // 传输一个bit需要的clk周期数 ;
    reg [31:0] count;  //  每发送一个bit为count一个计数周期
    reg [2:0] send_count;  // 记录正在发送第几个bit
    reg [3:0] bps_count;  //  传输前有一位strat位, 传输后有一位stop位, 一共传输10个bit

    // 根据band_set译码bps_DR
    always @(*) begin
        case (band_set)
            0: bps_DR = 100_0000/9600/20;  // bps=9600
            1: bps_DR = 100_0000/19200/20;  // bps=19200
            2: bps_DR = 100_0000/38400/20;  // bps=38400
            3: bps_DR = 100_0000/57600/20;  //  bps=57600
            default: bps_DR = 100_0000/115200/20;
        endcase
    end

    // 操作最小计数周期 count
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n)
            count <= 0;
        else if (send_en) begin
            if (count == bps_DR - 1)
                count <= 0;
            else
                count <= count + 1;
        end
        else 
            count <= 0;
    end

    // 操作bps_count,需要计数
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) 
            bps_count <= 0;
        else if(count == bps_DR - 1) begin
            if (bps_count == 10)   // 10也是一个完整的状态, 一共11个状态
                bps_count <= 0;
            else
                bps_count <= bps_count + 1;
        end
    end

    // 发送数据, 共10bit
     always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            uart_tx = 1'b0;
        end
        else begin
            case (bps_count)
                0: begin uart_tx = 1'b0; tx_done=1'b0;   end  // start位
                1: uart_tx = data[0];  // data[0]
                2: uart_tx = data[1];  // data[1]
                3: uart_tx = data[2];  // data[2]
                4: uart_tx = data[3];  // data[3]
                5: uart_tx = data[4];  // data[4]
                6: uart_tx = data[5];
                7: uart_tx = data[6];
                8: uart_tx = data[7];
                9: uart_tx = 1'b1;  // stop位 
                10: begin uart_tx = 1'b1; tx_done=1'b1;  end // 发送完成
                default: uart_tx = 1'b1;
            endcase 
        end
     end



endmodule