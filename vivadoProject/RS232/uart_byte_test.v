// 在uart_byte的基础上，每10ms发送一次串口数据，每次发送的数据值加一

module uart_byte_test (
    input clock,
    input reset_n,
    output uart_tx  // 子模块中已经定义为reg 这里在定义会出错
    );
    
    reg [31:0] count;  // 每周期为10ms
    parameter MCNT = 0.5e6;
    reg [7:0] epoch;  // 记录现在是第几个10ms周期
    reg send_en;      // 成为内部信号了
    wire [7:0] data;
    wire tx_done;
    assign data = epoch[7:0];

        // 调用模块
    uart_byte uart_byte_inst(
        .clock(clock),
        .reset_n(reset_n),
        .send_en(send_en),
        .band_set(4),
        .data(data),   // 以上是输入
        .uart_tx(uart_tx),
        .tx_done(tx_done)   // 根据tx_done控制send_en
    );


    // 操作count
    always @(posedge clock or negedge reset_n) begin
        if(!reset_n)
            count <= 0;
        else begin 
            if (count == MCNT -1)
                count <= 0;
            else
                count <= count + 1; 
        end
    end

    // 操作send_en
    always @(posedge clock or negedge reset_n) begin
        if(!reset_n)
            send_en <= 0;
        else if(count == 1)  // 从这里开始是clock上升沿控制
            send_en <= 1;    // 滞后
        else if(tx_done)
            send_en <= 0;
    end

    // 操作epoch
    always @(posedge clock or negedge reset_n) begin
        if(!reset_n)
            epoch <= 0;
        else begin
            if (count == MCNT -1)
                epoch <= epoch + 1;
            else
                epoch <= epoch;  // 要不要都行
        end
    end



endmodule