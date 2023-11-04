/*          使用串口来控制LED工作状态
    使用串口发送指定到fpga开发板，来控制led灯的工作状态 让led灯按照指定的亮灭模式亮灭，
    亮灭模式未知，由用户随机指定。8个变化状态为一个循环，每个变化状态的时间值可以根据不同的应用场景选择。
    如何使用串口接收8个byte的数据？

    引入uart_byte_rx  counter_led_3
    前者将串口接收的数据送到counter_led_3的ctrl和TIME 共5个byte
    制定协议 0x55 0xa5 TIME[7:0] TIME[15:8] TIME[23:16] TIME[31:24] ctrl[7:0] 0xf0
*/

module uart_rx_ctrl_led (
    input clk,
    input reset_n,
    input uart_rx,
    output reg led
);
    wire rx_done;
    wire [7:0] data;
    reg [7:0] ctrl;
    reg [31:0] state_time;
    // 定义栈接收数据与协议进行比对
    reg [7:0] memory[7:0];

    uart_byte_rx(
        .clock(clk),
        .reset_n(reset_n),
        .band_set(4),
        .uart_rx(uart_rx),
        .data(data),    // 以下是输出
        .rx_done(rx_done)
    );

    counter_led_3 counter_led_3_inst(
        .clock(clk),
        .reset_n(reset_n),
        .ctrl(ctrl),
        .TIME(state_time),
        .led(led)
    );

    // 数据移位更新
    always @(posedge rx_done or negedge reset_n) begin
        if (!reset_n) begin
            memory[0] <= 8'h00;
            memory[1] <= 8'h00;
            memory[2] <= 8'h00;
            memory[3] <= 8'h00;
            memory[4] <= 8'h00;
            memory[5] <= 8'h00;
            memory[6] <= 8'h00;
            memory[7] <= 8'h00;
        end else begin  // 移位寄存，memory[0]是最新的数据
            memory[0] <= memory[1];
            memory[1] <= memory[2];
            memory[2] <= memory[3];
            memory[3] <= memory[4];
            memory[4] <= memory[5];
            memory[5] <= memory[6];
            memory[6] <= memory[7];
            memory[7] <= data;
        end
    end

    // 协议比对
    always @(posedge rx_done) begin
        if (memory[0] == 8'h55 && memory[1] == 8'ha5 && memory[7] == 8'hf0) begin
            ctrl <= memory[6];
            state_time <= {memory[5], memory[4], memory[3], memory[2]};
        end
    end


    
endmodule
