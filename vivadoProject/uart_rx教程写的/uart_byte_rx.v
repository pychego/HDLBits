module uart_byte_rx (
    input clk,
    input reset_n,
    input band_set,
    input uart_rx,
    output reg [7:0] data,
    output reg rx_done
);

// 时序信号 uart_rx, rx_done rx_en
// 组合逻辑 nedge_uart_rx
    
    // 两个D触发器检测边沿
    reg [1:0] uart_rx_r;
    always @(posedge clock) begin
        uart_rx_r[1] <= uart_rx_r[0];
        uart_rx_r[0] <= uart_rx;
    end

    // 定义uart_rx的上升沿和下降沿
    wire pedge_uart_rx, nedge_uart_rx;
    assign pedge_uart_rx = (uart_rx_r == 2'b01);
    assign nedge_uart_rx = (uart_rx_r == 2'b10);  // 脉冲信号

    // 定义发送使能信号
    reg rx_en;
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) rx_en <= 1'b0;
        else if(nedge_uart_rx) rx_en <= 1'b1;
        else if(rx_done) rx_en <= 1'b0;
    end

    reg [31:0] bps_DR;  // 每一位采样16次，舍弃前5次和后4次
    always @(*) begin
        case(band_set) begin
            0: bps_DR = 1000_000_000/9600/16/20 - 1;  // 波特率9600
            1: bps_DR = 1000_000_000/19200/16/20 - 1;
            2: bps_DR = 1000_000_000/38400/16/20 - 1;
            3: bps_DR = 1000_000_000/57600/16/20 - 1;
            4: bps_DR = 1000_000_000/115200/16/20 - 1;
            default: bps_DR = 1000_000_000/9600/16/20 - 1;
        end
        endcase
    end

    wire bps_clk_16x;
    assign bps_clk_16x = bps_DR/2;  // 16次取值，每次都在正中间采样

    reg [31:0] count;
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            count <= 0;     // 只有数据来了之后计数才有意义
        end else if(rx_en) begin
            if(count == bps_DR - 1) begin      
            count <= 0;
        end else 
            count <= count + 1;
        end
    end

    // 记录采样的次数，每bit采样16次，共10bit，采样160次
    reg [31:0] bps_cnt; 
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            bps_cnt <= 0;
        end else if (bps_clk_16x) begin
            if(bps_cnt == 159) begin
                bps_cnt <= 0;
            end else begin
                bps_cnt <= bps_cnt + 1;
            end
        end
    end

    // 记录采样值
    reg [2:0] r_data[7:0];
    reg [2:0] sta_dbit[7:0];
    reg [2:0] sto_bit[7:0];








endmodule