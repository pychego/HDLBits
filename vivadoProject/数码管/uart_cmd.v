// 连接uart_byte_rx和counter_led_3
// 考虑实际的延迟，可以将 <= 改为 <= #1
//自己制定协议 0x55 0xa5 随便1byte new_time[31:24] new_time[23:16] new_time[15:8] new_time[7:0] 0xf0
// 共传输了8个byte
// 比对接收的数据，进行赋值
module uart_cmd (
    input             clk,
    input             reset_n,
    input      [ 7:0] data,       // 串口接收到的数据
    input             rx_done,    // 串口接收1byte完成
    output reg [31:0] new_time,
    output reg        agree_done  //串口接收和协议一致，对比完成 脉冲信号,一个时钟周期
);

    reg [7:0] memory[7:0];

    reg r_rx_done;
    always @(posedge clk) begin
        r_rx_done <= rx_done;
    end

    // 数据移位更新
    // 或者此处使用clk上升沿，将rx_done作为条件判断
    always @(posedge clk) begin
        if (rx_done) begin  // 移位寄存，memory[0]是最新的数据
            memory[0] <= #1 memory[1];
            memory[1] <= #1 memory[2];
            memory[2] <= #1 memory[3];
            memory[3] <= #1 memory[4];
            memory[4] <= #1 memory[5];
            memory[5] <= #1 memory[6];
            memory[6] <= #1 memory[7];
            memory[7] <= #1 data;
        end
    end

    // 必须先移位再判断，如果移位和判断在同一时刻，判断的是之前的数据
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            agree_done <= #1 0;
            new_time <= #1 32'h00000000;
        end else if (r_rx_done) begin
            if (memory[0] == 8'h55 && memory[1] == 8'ha5 && memory[7] == 8'hf0) begin
                new_time <= #1 {memory[3], memory[4], memory[5], memory[6]};
                agree_done <= #1 1;
            end 
        end else agree_done <= #1 0;    // 注意agree_done高电平的时间,一个clk
    end

    /*
    // 解决先移位后对比的另一个办法 使用寄存器让r_rx_done比rx_done晚一个节拍
    reg r_rx_done;
    always @(posedge clk) begin
        r_rx_done <= rx_done;
    end
    // 使用rx_done电平信号进行移位
    // r_rx_done电平信号进行协议比对
    */
endmodule
