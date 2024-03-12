// 采集7次数据确定该次数据的值

module sample_card (
    input             clock,
    input             reset_n,
    input             uart_rx,
    input      [31:0] bps_DR,
    output reg        sample_done,  // 采样结束信号,脉冲信号
    output reg        dvalue        // 投票得到采集的数值
);
    reg [31:0] count;
    reg [ 2:0] sample_count;

    // 操作最小计数值count
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            count <= 0;
        end else begin
            if (count == bps_DR / 8) count <= 0;
            else count <= count + 1;
        end
    end

    // 操作sample_count
    reg [7:0] sample;  // 舍弃最低位
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            sample_count <= 0;
            sample <= 8'b0;
        end else begin
            if (count == bps_DR / 8) begin  // bps_DR分为8段,取中间的7个值
                if (sample_count == 7) begin
                    sample_count <= 0;
                end else begin
                    sample_count <= sample_count + 1;
                    sample[sample_count+1] <= uart_rx;
                    // sample的1~7是存储位
                end
            end
        end
    end

    // 操作sample_done 脉冲信号
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) sample_done <= 0;
        else if (count == bps_DR / 8) begin
            if (sample_count == 7) sample_done <= 1;
            else sample_done <= 0;
        end
    end

    // 投票得到采集的数值
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            dvalue <= 0;
        end else if (sample_done) begin
            if(sample[1]+sample[2]+sample[3]+sample[4]+sample[5]+sample[6]+sample[7] >= 4)
                dvalue <= 1;
            else dvalue <= 0;
        end
    end

endmodule
