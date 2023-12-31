// 在uart_byte的基础上，每10ms发送一次串口数据，每次发送的数据值加一

module uart_byte_test (
    input  clock,
    input  reset_n,
    output uart_tx   // 子模块中已经定义为reg 这里在定义会出错
);

    reg [31:0] count;  // 每周期为10ms
    parameter MCNT = 500_000;  // 10ms周期数
    reg  [7:0] epoch;  // 记录现在是第几个10ms周期
    reg        send_go;  // 成为内部信号了
    wire [7:0] data;
    wire       tx_done;  // 必须是wire，reg会报错 module输出用wire接
    assign data = epoch[7:0];
    /*  时序控制信号 uart_tx tx_done send_go  
    组合逻辑信号 data 
*/
    // 调用模块
    uart_byte uart_byte_inst (
        .clock(clock),
        .reset_n(reset_n),
        .send_go(send_go),
        .band_set(4),
        .data(data),  // 以上是输入
        .uart_tx(uart_tx),
        .tx_done(tx_done)
    );


    // 操作count
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) count <= 0;
        else begin
            if (count == MCNT - 1) count <= 0;
            else count <= count + 1;
        end
    end

    // 操作send_go 每个10ms刚开始send_go来一个高脉冲
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) send_go <= 0;
        else if (count == 1) send_go <= 1;
        else send_go <= 0;
    end
    // count=1 -> bps_count=11 -> tx_done=1 -> send_en=0 ->
    //  bps_count=0 -> tx_done=0, 因此tx_done=1保持了三个clock


    // 操作epoch
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) epoch <= 0;
        else begin
            if (count == MCNT - 1) epoch <= epoch + 1;
            else epoch <= epoch;  // 要不要都行
        end
    end

endmodule
