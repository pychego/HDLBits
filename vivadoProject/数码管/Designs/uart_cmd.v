/*
    考虑实际的延迟，可以将 <= 改为 <= #1
    自己制定协议 0x55 0xa5 随便1byte new_time[31:24] new_time[23:16] new_time[15:8] new_time[7:0] 0xf0
    共传输了8个byte    比对接收的数据，对new_time进行赋值
    uart_cmd input [7:0] data    串口接收到的8byte数据
             input rx_done       串口接收1byte完成 脉冲信号
             output agree_done   串口接收data和协议一致，对比完成 脉冲信号,一个时钟周期
             output [31:0] new_time 串口接收到的时间
*/
module uart_cmd (
    input             clk,
    input             reset_n,
    input      [ 7:0] data,       
    input             rx_done,    
    output reg [31:0] new_time,
    output reg        agree_done  
);

    reg [7:0] memory[7:0];

    // key rx_done延迟一个节拍rx_done控制移位 r_rx_done控制协议对比
    reg r_rx_done;
    always @(posedge clk) begin
        r_rx_done <= rx_done;
    end

    // 数据移位更新 移位寄存器不需要reset_n
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

endmodule
