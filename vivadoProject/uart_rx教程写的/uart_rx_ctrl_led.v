/*          使用串口来控制LED工作状态
    使用串口发送指定到fpga开发板，来控制led灯的工作状态 让led灯按照指定的亮灭模式亮灭，
    亮灭模式未知，由用户随机指定。8个变化状态为一个循环，每个变化状态的时间值可以根据不同的应用场景选择。
    如何使用串口接收8个byte的数据？

    引入uart_byte_rx  counter_led_3
    前者将串口接收的数据送到counter_led_3的ctrl和TIME 共5个byte
    制定协议 0x55 0xa5 TIME[7:0] TIME[15:8] TIME[23:16] TIME[31:24] ctrl[7:0] 0xf0
*/

module uart_rx_ctrl_led (
    input  clock,
    input  reset_n,
    input  uart_rx,
    output led
);
    // 模块之间的连线不用纠结输出输出用什么，连线都用wire
    wire rx_done;
    wire [7:0] data;
    wire [7:0] ctrl;
    wire [31:0] state_time;

    // reg width name number/depth
    wire [7:0] memory[7:0];  // 定义栈接收数据与协议进行比对
    wire flag;  // 用于标记是否接收到了协议

    // 接收串口信号，传送给uart_cmd模块
    uart_byte_rx uart_byte_rx_inst(
        .clock(clock),
        .reset_n(reset_n),
        .band_set(4),
        .uart_rx(uart_rx),
        .data(data),  // 以下是输出
        .rx_done(rx_done)
    );

    // 将接收的信号送给led模块的ctrl和state_time
    uart_cmd uart_cmd_inst (
        .clock     (clock),
        .reset_n   (reset_n),
        .data      (data),
        .rx_done   (rx_done),
        .ctrl      (ctrl),
        .state_time(state_time)
    );

    // 根据输入控制信号点灯
    counter_led_3 counter_led_3_inst (
        .clock     (clock),
        .reset_n   (reset_n),
        .ctrl      (ctrl),
        .state_time(state_time),
        .led       (led)
    );


endmodule
